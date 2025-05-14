extends Control

const Globals = preload("res://scripts/globals.gd")

@onready var button = $Button
@onready var health_bar = $HealthBar

@export var ore_type: Globals.PlanetName


func _ready() -> void:
	var screen_size = get_viewport_rect().size
	button.position = Vector2(100, 100)
	_initiate_healthbar(health_bar, screen_size)
	
	if !Player.checkpoints["intro_five"]:
		Dialogic.start("intro_five")
		Player.checkpoints["intro_five"] = true
		
	if !Player.checkpoints["ice_cream"] and ore_type == Globals.PlanetName.ICE_CREAM:
		Dialogic.start("furo_ice_cream")
		Player.checkpoints["furo_ice_cream"] = true


func _initiate_healthbar(health_bar_bar: TextureProgressBar, screen_size: Vector2):
	health_bar_bar.size = Vector2(screen_size.x * 0.1, 64)
	health_bar_bar.pivot_offset = Vector2(health_bar_bar.size.x * 0.5, health_bar_bar.size.y * 0.5)
	health_bar_bar.position = screen_size * 0.5 - Vector2(health_bar_bar.size.x * 0.5, screen_size.y * 0.25)
	health_bar_bar.max_value = Ores.max_health_by_type[ore_type]
	health_bar_bar.value = health_bar_bar.max_value


func _on_button_pressed() -> void:
	SceneSwitcher.switch_scene("res://scenes/navi.tscn")


func _on_ore_template_notify_healthbar(new_health: float) -> void:
	health_bar.value = new_health
