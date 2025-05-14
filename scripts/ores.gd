extends Area2D

# i should have turned the planets themselves into templates too... too late i guess
signal notify_healthbar(new_health: int)

const Globals = preload("res://scripts/globals.gd")

@onready var sprite: Sprite2D = $%OreTexture
@onready var collider: CollisionShape2D = $%OreCollisionShape
@onready var healthbar: TextureProgressBar = $HealthBar

@export var ore_type: Globals.PlanetName # this is so fkn confusing hahaha
@export var max_health: int = 10
@export var ore_texture: Texture2D
@export var ore_size: Vector2 = Vector2.ZERO  # Leave at (0,0) to use original texture size
@export var reward_amount: int = 1
@export var price: int = 1

var screen_size: Vector2
var current_health: int = 0
var max_health_by_type: Dictionary[Globals.PlanetName, int] = {
	Globals.PlanetName.IRON: 10,
	Globals.PlanetName.DIAMOND: 100,
	Globals.PlanetName.OBSIDIAN: 500,
	Globals.PlanetName.PLATINUM: 750,
	Globals.PlanetName.MAGMA: 1000,
	Globals.PlanetName.EXOTIC_MATTER: 2000,
	Globals.PlanetName.STARDUST: 7500,
	Globals.PlanetName.ICE_CREAM: 50000,
	Globals.PlanetName.ANTIMATTER: 15000
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
	Globals.PlanetName.ANTIMATTER: "Mysterious Antimatter"
}

var ore_textures: Dictionary[Globals.PlanetName, String] = {
	Globals.PlanetName.IRON: "res://tres/iron_ore.tres",
	Globals.PlanetName.DIAMOND: "res://tres/diamond_ore.tres",
	Globals.PlanetName.OBSIDIAN: "res://tres/obsidian.tres",
	Globals.PlanetName.PLATINUM: "res://tres/platinum.tres",
	Globals.PlanetName.MAGMA: "res://tres/magma.tres",
	Globals.PlanetName.EXOTIC_MATTER: "res://tres/exotic_matter.tres",
	Globals.PlanetName.STARDUST: "res://tres/stardust.tres",
	Globals.PlanetName.ICE_CREAM: "res://img/ores/ice_cream.png",
	Globals.PlanetName.ANTIMATTER: "res://tres/antimatter.tres"
}


func _ready():
	# much of this was done by ChatGPT when i first started with this,
	# and i have no idea what i am looking at...
	
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


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		_on_click()


func _show_popup_text(text: String):
	var dmg_scene = preload("res://scenes/damage_pop_up.tscn")
	var dmg_text = dmg_scene.instantiate()
	get_tree().root.add_child(dmg_text)
	
	dmg_text.show_damage(text)


func _on_click():
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
		Player.checkpoints["exotic_matter"] = true
		
	if !Player.checkpoints["anti_matter"] and ore_type == Globals.PlanetName.ANTIMATTER:
		Dialogic.start("furo_antimatter")
		Player.checkpoints["anti_matter"] = true
	
	current_health = max_health
	emit_signal("notify_healthbar", max_health)


func _on_dialogic_ended():
	SceneSwitcher.switch_scene("res://scenes/bridge.tscn")
