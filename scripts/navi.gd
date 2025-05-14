extends Control

const Globals = preload("res://scripts/globals.gd")

var main_animation: String = "MainAnimation"
var planet_instances: Dictionary[Globals.PlanetName, Node] = {}
var rotating = false


func _ready():
	var screen_size = get_viewport_rect().size
	
	# instantiate planets
	for planet in Globals.planet_animation_nodes.keys():
		var scene_path = Globals.planet_animation_nodes[planet]
		var scene_res: PackedScene = scene_path
		var instance = scene_res.instantiate()
		if !planet_available(planet):
			instance.modulate = Color(0.4, 0.4, 0.4, 1)
		add_child(instance)
		planet_instances[planet] = instance
		
		# connect the signals
		instance.connect("mouse_entered", Callable(self, "_on_planet_mouse_entered").bind(planet))
		instance.connect("mouse_exited", Callable(self, "_on_planet_mouse_exited").bind(planet))
		instance.connect("input_event", Callable(self, "_on_planet_input_event").bind(planet))
	
		# scale all planets
		var sprite = planet_instances[planet].get_child(0)
		var base_resolution = 1440
		var dynamic_scale = screen_size.y / base_resolution
		if sprite:
			sprite.scale = Vector2.ONE * get_planet_scale(Globals.planet_types[planet]) * dynamic_scale
	
	# place all planets
	# since the placement is kinda arbitrary, ima do it all manually
	
	# this should roughly work out for all planets, except the black hole
	var planet_size: Vector2 = get_planet_size(Globals.PlanetName.ICE_CREAM)
	var black_hole_size: Vector2 = get_planet_size(Globals.PlanetName.ANTIMATTER)
	
	# this might be too long, but come on... if i split this up it will be even less readable
	planet_instances[Globals.PlanetName.ANTIMATTER].position = Vector2(screen_size.x - black_hole_size.x, screen_size.y / 4)
	planet_instances[Globals.PlanetName.DIAMOND].position = Vector2(screen_size.x / 5, screen_size.y / 3)
	planet_instances[Globals.PlanetName.EXOTIC_MATTER].position = Vector2(screen_size.x / 2 + 2 * planet_size.x, screen_size.y / 2)
	planet_instances[Globals.PlanetName.ICE_CREAM].position = Vector2(screen_size.x - planet_size.x, screen_size.y - planet_size.y)
	planet_instances[Globals.PlanetName.IRON].position = Vector2(screen_size.x / 8, screen_size.y - planet_size.y * 2)
	planet_instances[Globals.PlanetName.MAGMA].position = Vector2(screen_size.x / 2, screen_size.y / 4)
	planet_instances[Globals.PlanetName.OBSIDIAN].position = Vector2(screen_size.x / 3, screen_size.y / 2)
	planet_instances[Globals.PlanetName.PLATINUM].position = Vector2(screen_size.x / 3, screen_size.y - planet_size.y * 1.5)
	planet_instances[Globals.PlanetName.STARDUST].position = Vector2(screen_size.x * 0.6, screen_size.y - planet_size.y)
	
	if !Player.checkpoints["intro_two"]:
		Dialogic.start("intro_two")
		Player.checkpoints["intro_two"] = true


func planet_available(planet: Globals.PlanetName) -> bool:
	for req: Item.ItemName in Globals.planet_requirements[planet]:
		for item in Player.item_list:
			if req == item.item_type:
				var req_lev = Globals.planet_requirements[planet][req]
				if item.level < req_lev:
					return false
	if planet == Globals.PlanetName.ICE_CREAM and !Player.defeated_ruru:
		return false
	return true


func get_first_animation_frame(planet_name: Globals.PlanetName) -> Texture2D:
	var sprite_frames: SpriteFrames = planet_instances[planet_name].get_child(0).sprite_frames
	return sprite_frames.get_frame_texture(main_animation, 0)


func get_planet_size(planet_name: Globals.PlanetName) -> Vector2:
	var texture: Texture2D = get_first_animation_frame(planet_name)
	var texture_size: Vector2 = texture.get_size()
	return texture_size * planet_instances[planet_name].get_child(0).get_scale()


func get_planet_scale(type: Globals.PlanetType) -> float:
	if type == Globals.PlanetType.PLANET:
		return 1.0
	return 1.5


func _on_navi_back_to_menu_button_pressed() -> void:
	SceneSwitcher.switch_scene("res://scenes/bridge.tscn")


func _start_animation(planet_name: Globals.PlanetName) -> void:
	planet_instances[planet_name].get_child(0).play(main_animation)


func _stop_animation(planet_name: Globals.PlanetName) -> void:
	planet_instances[planet_name].get_child(0).stop()


func _on_planet_mouse_entered(planet: Globals.PlanetName) -> void:
	if (not planet_available(planet)) or rotating:
		return
	rotating = true
	_start_animation(planet)


func _on_planet_mouse_exited(planet: Globals.PlanetName) -> void:
	if (not rotating) or (not planet_available(planet)):
		return
	rotating = false
	_stop_animation(planet)


func _on_planet_input_event(_viewport, event, _shape_idx, planet: Globals.PlanetName) -> void:
	if event is InputEventMouseButton and event.pressed:
		if !planet_available(planet):
			var reqs = Globals.planet_requirements[planet]
			var req_string = ""
			for req in reqs:
				for itm in Globals.planet_requirements[planet]:
					req_string = Item.item_names[itm][Globals.planet_requirements[planet][itm]] + ", "
			InfoPopupManager.show_warning("This planet isn't available yet. \nRequirements: %s" % req_string.substr(0, req_string.length() - 2))
			return
		AudioPlayer.play_sound(AudioPlayer.Sound.BUTTON_CLICK)
		SceneSwitcher.switch_scene("res://scenes/fight_scene.tscn", planet)
