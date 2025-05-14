extends Control

const BUTTON_SCALE := 0.15  # percent of shorter screen side
const Globals = preload("res://scripts/globals.gd")

@onready var furo_image: TextureRect = $FuroImage
@onready var ruru_image: TextureRect = $RuruImage
@onready var furo_image_animation: AnimationPlayer = $FuroImage/AnimationPlayer
@onready var ruru_image_animation: AnimationPlayer = $RuruImage/AnimationPlayer
@onready var bgm: AudioStreamPlayer2D = $BGM

@export var button_textures: Dictionary[ButtonName, Texture2D]

var button_animation_script = load("res://scripts/menu_button_animation.gd")
var workshop_item_scene: PackedScene = preload("res://scenes/workshop_item.tscn")
var namazon_item_scene: PackedScene = preload("res://scenes/namazon_item.tscn")
var screen_size: Vector2
var dynamic_scale: float
var navi_scene_path: NodePath = "res://scenes/navi.tscn"
var button_list = [ButtonName.SLEEP, ButtonName.WORKSHOP, ButtonName.NAVI, ButtonName.NAMAZON, ButtonName.QUIT]


enum ButtonName {
	SLEEP,
	WORKSHOP,
	NAVI,
	NAMAZON,
	QUIT,
}


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("god_mode"):
		Player.damage = 10000
		Player.space_dollars = 10000000
		for ore in Player.ore_dictionary:
			Player.ore_dictionary[ore] = 10000000


func _ready():
	furo_image.visible = false
	ruru_image.visible = false
	
	var button_container = $ButtonContainer
	
	for ore in get_tree().get_nodes_in_group("ores"):
		ore.connect("ore_mined", Callable(self, "_on_ore_mined"))
	
	screen_size = get_viewport_rect().size
	# looking through the code rn, and wtf did chatgpt give me here xD
	var base_size = min(screen_size.x, screen_size.y)
	var button_size = base_size * BUTTON_SCALE
	# writing this after the planet scaling... this should probably be globally defined somewhere, but i'm lazy
	var base_resolution = 1440
	dynamic_scale = screen_size.y / base_resolution

	var col_one_x = button_container.size.x * 0.5
	var col_two_x = col_one_x + button_size * 0.5
	var base_y = -button_container.position.y * 0.5 - button_size * 0.5
	var y_scaler = button_size * 0.8 # i love magic numbers; fuck around and find out. best approach

	var button_dictionary: Dictionary[ButtonName, TextureButton] = {}
	for index in range(button_list.size()):
		var button_name = button_list[index]
		button_dictionary[button_name] = _create_button(button_name, button_size)
		
		button_dictionary[button_name].connect("pressed", Callable(self, "_button_pressed").bind(button_name))

		var x: float
		var y: float
		
		if index % 2 == 0:
			x = col_one_x
			y = base_y + y_scaler * index
		else:
			x = col_two_x
			y = base_y + y_scaler * index
		
		button_dictionary[button_name].position = Vector2(x, y)
		button_container.add_child(button_dictionary[button_name])
	
	# ***************************************************************************** #
	# I KID YOU NOT, THIS FUCKING IMAGE POSITION TOOK ME A SOLID HOUR TO FIGURE OUT #
	# ***************************************************************************** #
	
	var base_image_scale = 0.3 # on 1440p
	var image_scale = base_image_scale * dynamic_scale
	furo_image.scale = Vector2.ONE * image_scale
	var furo_im_y = furo_image.position.y + furo_image.size.y * image_scale
	var missing_bit = screen_size.y - furo_im_y
	furo_image.position.y = furo_image.position.y + missing_bit
	furo_image.position.x = screen_size.x * 0.5 - (furo_image.size.x * image_scale) * image_scale
	
	var ruru_scale = 0.8
	ruru_image.scale = Vector2.ONE * ruru_scale
	var ruru_im_y = ruru_image.position.y + ruru_image.size.y * ruru_scale
	var missing_ruru = screen_size.y - ruru_im_y
	ruru_image.position.y = ruru_image.position.y + missing_ruru
	ruru_image.position.x = screen_size.x * 0.4
	
	if !Player.checkpoints["intro_one"]:
		Dialogic.start("intro_one")
		Player.checkpoints["intro_one"] = true
		Dialogic.timeline_ended.connect(show_navi_button_popup)
		
	if !Player.checkpoints["intro_seven"] and Player.checkpoints["intro_six"]:
		Dialogic.start("intro_seven")
		Player.checkpoints["intro_seven"] = true
		Dialogic.timeline_ended.connect(show_upgrade_popup)
		
	if Player.checkpoints["intro_eight"]:
		bgm.play()
		character_fade_in(furo_image, furo_image_animation)
		
	if Player.defeated_ruru:
		furo_image.position.x = furo_image.position.x - screen_size.x * 0.1
		character_fade_in(ruru_image, ruru_image_animation)


func character_fade_in(image: TextureRect, anim: AnimationPlayer) -> void:
	image.visible = true
	anim.play("fade_in")


func show_navi_button_popup() -> void:
	InfoPopupManager.show_info("Clicking on the explore button in the middle will take you to the navigation system! Try it out!")


func show_upgrade_popup() -> void:
	InfoPopupManager.show_info("With the just mined ore, you can now upgrade your ship! What does the upgrade do you ask? Well, don't ask!")


func play_pop_up_animation(animation_player: AnimationPlayer) -> void:
	animation_player.play("pop_up_animation")


func setup_scene(scene: Control, scene_name: String, margin_container: MarginContainer, icon: TextureRect, icon_texture: Texture2D) -> void:
	scene.pivot_offset = Vector2(screen_size.x * 0.5, screen_size.y * 0.5)
	scene.set_title(scene_name)
	icon.texture = icon_texture
	scene.visible = true
	var margins_lr = screen_size.x * 0.05
	var margins_tb = screen_size.y * 0.08
	margin_container.add_theme_constant_override("margin_left", margins_lr)
	margin_container.add_theme_constant_override("margin_right", margins_lr)
	margin_container.add_theme_constant_override("margin_top", margins_tb)
	margin_container.add_theme_constant_override("margin_bottom", margins_tb)


func open_namazon() -> void:
	var namazon_scene = $NamazonPopUp
	var namazon_animation_player = $NamazonPopUp/PopUpAnimation
	var namazon_margin_container = $NamazonPopUp/MarginContainer/MarginContainer
	var popup_icon = $NamazonPopUp/MarginContainer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/HBoxContainer/PopUpIcon
	var namazon_icon = preload("res://img/ui/bridge/namazon_menu_button.png")
	setup_scene(namazon_scene, "NAMAZON", namazon_margin_container, popup_icon, namazon_icon)
	_add_namazon_items()
	_refresh_player_items("Namazon")
	play_pop_up_animation(namazon_animation_player)


func open_workshop() -> void:
	# these open functions could have easily been one hahaha
	var workshop_scene = $WorkshopPopUp
	workshop_scene.connect("open_sleep", Callable(_open_sleep))
	var workshop_animation_player = $WorkshopPopUp/PopUpAnimation
	var workshop_margin_container = $WorkshopPopUp/MarginContainer/MarginContainer
	var popup_icon = $WorkshopPopUp/MarginContainer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/HBoxContainer/PopUpIcon
	var workshop_icon = preload("res://img/ui/bridge/workshop_menu_button.png")
	setup_scene(workshop_scene, "WORKSHOP", workshop_margin_container, popup_icon, workshop_icon)
	_add_workshop_items()
	_refresh_player_items("Workshop")
	play_pop_up_animation(workshop_animation_player)


func _open_sleep():
	InfoPopupManager.show_info("Clicking in the top button to sleep will save the game. The gamestate is also saved every 60 seconds.")
	Player.checkpoints["sleep"] = true


func _add_workshop_items() -> void:
	for item in Player.item_list:
		if Item.is_unlocked(item):
			var list_item = workshop_item_scene.instantiate()
			var hflow_container: HFlowContainer = get_node("WorkshopPopUp/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/HFlowContainer")
			list_item.connect("item_upgraded", Callable(self, "_redraw_workshop_items").bind(hflow_container))
			list_item.connect("refresh_workshop", Callable(self, "_refresh_player_items").bind("Workshop"))
			var item_size = list_item.get_child(0).size.x
			list_item.item = item
			hflow_container.add_theme_constant_override("h_separation", item_size + 10)
			hflow_container.add_theme_constant_override("v_separation", item_size + 10)
			hflow_container.add_child(list_item)


func _add_namazon_items() -> void:
	for item in Player.shop_items:
		if item.item_type == Item.get_item("ENGINE"):
			continue
		var list_item = namazon_item_scene.instantiate()
		var hflow_container: HFlowContainer = get_node("NamazonPopUp/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/HFlowContainer")
		list_item.connect("item_purchased", Callable(self, "_redraw_namazon_items").bind(hflow_container))
		list_item.connect("refresh_namazon", Callable(self, "_refresh_player_items").bind("Namazon"))
		var item_size = list_item.get_child(0).size.x
		list_item.item = item
		hflow_container.add_theme_constant_override("h_separation", item_size + 10)
		hflow_container.add_theme_constant_override("v_separation", item_size + 10)
		hflow_container.add_child(list_item)


func _redraw_namazon_items(container: HFlowContainer):
	for item in container.get_children():
		item._ready()


func _redraw_workshop_items(container: HFlowContainer):
	for item in container.get_children():
		item._ready()
	if !Player.checkpoints["intro_eight"]:
		Dialogic.timeline_ended.disconnect(show_upgrade_popup)
		Dialogic.start("intro_eight")
		Player.checkpoints["intro_eight"] = true


func _add_player_items(scene_name: String) -> void:
	var player_item_list: ItemList = get_node("%sPopUp/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemList" % scene_name)
	var item_list_count = player_item_list.item_count
	player_item_list.icon_scale = dynamic_scale
	player_item_list.add_item("Damage: %s" % Player.damage)
	player_item_list.add_item("Health: %s" % Player.health)
	player_item_list.add_item(str(Player.space_dollars), preload("res://img/currency/coin.png"), false)
	for ore in Globals.PlanetName:
		var ore_type: Globals.PlanetName = Globals.PlanetName.get(ore)
		if ore_type == Globals.PlanetName.ICE_CREAM:
			continue
		player_item_list.add_item(str(Player.ore_dictionary[ore_type]), load(Ores.ore_textures[ore_type]), false)


func _refresh_player_items(scene_name: String) -> void:
	var player_item_list: ItemList = get_node("%sPopUp/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemList" % scene_name)
	var player_item_count = player_item_list.item_count
	for i in range(player_item_count):
		player_item_list.remove_item(0)
	_add_player_items(scene_name)


func _create_button(button_name: ButtonName, button_size: float) -> TextureButton:
	
	var btn = TextureButton.new()
	btn.set_script(button_animation_script)
	btn.base_scale = Vector2.ONE * dynamic_scale
	btn.texture_normal = button_textures[button_name]
	btn.size_flags_horizontal = Control.SIZE_EXPAND
	btn.size_flags_vertical = Control.SIZE_EXPAND
	btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	btn.pivot_offset = Vector2(button_size * 0.5, button_size * 0.5)
	
	return btn


func _button_pressed(button_name: ButtonName) -> void:
	
	match button_name:
		ButtonName.QUIT:
			get_tree().quit(0)
		ButtonName.NAMAZON:
			if !Player.checkpoints["intro_six"] or !Player.checkpoints["intro_eight"]:
				InfoPopupManager.show_warning("You can't do that yet.")
				return
			open_namazon()
			AudioPlayer.play_sound(AudioPlayer.Sound.BUTTON_CLICK)
		ButtonName.WORKSHOP:
			if !Player.checkpoints["intro_six"]:
				InfoPopupManager.show_warning("You can't do that yet.")
				return
			open_workshop()
			AudioPlayer.play_sound(AudioPlayer.Sound.BUTTON_CLICK)
		ButtonName.SLEEP:
			Player._save_state()
			InfoPopupManager.show_info("Game Saved")
			AudioPlayer.play_sound(AudioPlayer.Sound.BUTTON_CLICK)
		ButtonName.NAVI:
			SceneSwitcher.switch_scene(navi_scene_path)
