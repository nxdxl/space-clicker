extends Area2D

signal notify_healthbar(new_health: int)

const Globals = preload("res://scripts/globals.gd")

@onready var sprite: Sprite2D = $%OreTexture
@onready var collider: CollisionShape2D = $%OreCollisionShape
@onready var healthbar: TextureProgressBar = $HealthBar

var ore_type: Globals.PlanetName
var ore_texture: Texture2D
var max_health: int
var current_health: int
var ore_size: Vector2 = Vector2.ZERO  # Leave at (0,0) to use original texture size
var reward_amount: int
var price: int
var screen_size: Vector2

var max_health_by_type: Dictionary[Globals.PlanetName, int] = {
	Globals.PlanetName.IRON: 10,
	Globals.PlanetName.DIAMOND: 100,
	Globals.PlanetName.OBSIDIAN: 500,
	Globals.PlanetName.PLATINUM: 750,
	Globals.PlanetName.MAGMA: 1000,
	Globals.PlanetName.EXOTIC_MATTER: 2000,
	Globals.PlanetName.STARDUST: 7500,
	Globals.PlanetName.ICE_CREAM: 50000,
	Globals.PlanetName.ANTIMATTER: 15000,
}

var ore_type_to_name: Dictionary[Globals.PlanetName, String] = {
	Globals.PlanetName.IRON: "Iron Ore",
	Globals.PlanetName.DIAMOND: "Diamond Ore",
	Globals.PlanetName.OBSIDIAN: "Obsidian",
	Globals.PlanetName.PLATINUM: "Platinum Ore",
	Globals.PlanetName.MAGMA: "Hardened Magma",
	Globals.PlanetName.EXOTIC_MATTER: "Exotic Matter",
	Globals.PlanetName.STARDUST: "Stardust",
	Globals.PlanetName.ICE_CREAM: "Magical Ice Cream",
	Globals.PlanetName.ANTIMATTER: "Mysterious Antimatter",
}

var reward_by_type: Dictionary[Globals.PlanetName, int] = {
	Globals.PlanetName.IRON: 1,
	Globals.PlanetName.DIAMOND: 2,
	Globals.PlanetName.OBSIDIAN: 3,
	Globals.PlanetName.PLATINUM: 2,
	Globals.PlanetName.MAGMA: 5,
	Globals.PlanetName.EXOTIC_MATTER: 1,
	Globals.PlanetName.STARDUST: 1,
	Globals.PlanetName.ICE_CREAM: 1,
	Globals.PlanetName.ANTIMATTER: 1,
}

var price_by_type: Dictionary[Globals.PlanetName, int] = {
	Globals.PlanetName.IRON: 1,
	Globals.PlanetName.DIAMOND: 100,
	Globals.PlanetName.OBSIDIAN: 150,
	Globals.PlanetName.PLATINUM: 300,
	Globals.PlanetName.MAGMA: 500,
	Globals.PlanetName.EXOTIC_MATTER: 1000,
	Globals.PlanetName.STARDUST: 5000,
	Globals.PlanetName.ICE_CREAM: 50000,
	Globals.PlanetName.ANTIMATTER: 10000,
}

var ore_textures: Dictionary[Globals.PlanetName, Texture2D] = {
	Globals.PlanetName.IRON: preload("res://tres/iron_ore.tres"),
	Globals.PlanetName.DIAMOND: preload("res://tres/diamond_ore.tres"),
	Globals.PlanetName.OBSIDIAN: preload("res://tres/obsidian.tres"),
	Globals.PlanetName.PLATINUM: preload("res://tres/platinum.tres"),
	Globals.PlanetName.MAGMA: preload("res://tres/magma.tres"),
	Globals.PlanetName.EXOTIC_MATTER: preload("res://tres/exotic_matter.tres"),
	Globals.PlanetName.STARDUST: preload("res://tres/stardust.tres"),
	Globals.PlanetName.ICE_CREAM: preload("res://img/ores/ice_cream.png"),
	Globals.PlanetName.ANTIMATTER: preload("res://tres/antimatter.tres"),
}


func _ready():	
	screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x * 0.5, screen_size.y * 0.5)
	
	current_health = max_health
	
	# Assign texture if set
	if ore_texture:
		sprite.texture = ore_texture
		var tex_size = ore_texture.get_size()
		if ore_size != Vector2.ZERO:
			sprite.scale = ore_size / tex_size
		else:
			sprite.scale = Vector2.ONE
	else:
		push_warning("No texture assigned to ore_texture")
	connect("input_event", Callable(self, "_on_input_event"))


func set_stats(this_ore_type: Globals.PlanetName) -> void:
	max_health = max_health_by_type[this_ore_type]
	current_health = max_health
	ore_texture = ore_textures[this_ore_type]
	ore_type = this_ore_type
	ore_size = Vector2.ZERO
	reward_amount = reward_by_type[this_ore_type]
	price = price_by_type[this_ore_type]
	sprite.texture = ore_textures[this_ore_type]
	
	print_debug("health %s, health %s, type %s, reward %s, price %s" % [max_health, current_health, ore_type, reward_amount, price])


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		_on_click()


func _show_popup_text(text: String):
	var dmg_scene = preload("res://scenes/damage_pop_up.tscn")
	var dmg_text = dmg_scene.instantiate()
	get_tree().root.add_child(dmg_text)
	
	dmg_text.show_damage(text)


func _on_click():
	Player.add_click()
	current_health -= Player.damage
	emit_signal("notify_healthbar", current_health)
	print("%s clicked. Health: %d" % [ore_type_to_name[ore_type], current_health])
	if current_health <= 0:
		_mine_ore()
	else:
		_show_popup_text("%s" % Player.damage)


func _mine_ore():
	_show_popup_text("Ore mined: %s x%s" % [ore_type_to_name[ore_type], reward_amount])
	print("Ore mined! (%s)" % ore_type_to_name[ore_type])
	if not ore_type in Player.ore_dictionary:
		Player.ore_dictionary[ore_type] = 0
	Player.ore_dictionary[ore_type] += reward_amount
	
	if !Player.checkpoints["intro_six"]:
		Dialogic.start("intro_six")
		Player.checkpoints["intro_six"] = true
		
		Dialogic.timeline_ended.connect(_on_dialogic_ended)
	
	if !Player.checkpoints["exotic_matter"] and ore_type == Globals.PlanetName.EXOTIC_MATTER:
		Dialogic.start("furo_exotic_matter")
		# this is so stupid. you HAVE to pass all args, even if they're kwargs??
		Player.achieve(Achievements.Achievement.DUMMY, Achievements.HiddenAchievement.VERY_EXOTIC)
		Player.checkpoints["exotic_matter"] = true
		
	if !Player.checkpoints["anti_matter"] and ore_type == Globals.PlanetName.ANTIMATTER:
		Dialogic.start("furo_antimatter")
		Player.checkpoints["anti_matter"] = true
	
	current_health = max_health
	emit_signal("notify_healthbar", max_health)


func _on_dialogic_ended():
	SceneSwitcher.switch_scene("res://scenes/bridge.tscn")
