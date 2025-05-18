extends Control

const Globals = preload("res://scripts/globals.gd")

@onready var health_bar = $%HealthBar
@onready var center = $CenterContainer
@onready var panel = $Panel
@onready var bgm = $BGM

var ore_scene = preload("res://scenes/ore_template.tscn")
var ore_instance = ore_scene.instantiate()
var planet: Globals.PlanetName
var screen_size: Vector2


func init(target_planet: Globals.PlanetName) -> void:
	planet = target_planet


func _ready() -> void:
	UI.last_scene = "res://scenes/navi.tscn"
	UI.modular_back_button.text = "NAVI"
	screen_size = get_viewport_rect().size
	center.add_child(ore_instance)
	ore_instance.set_stats(planet)
	
	var stylebox := StyleBoxTexture.new()
	stylebox.texture = Globals.planet_background_textures[planet]
	panel.add_theme_stylebox_override("panel", stylebox)
	
	bgm.play()
	_initiate_healthbar(health_bar)
	
	if !Player.checkpoints["intro_five"]:
		Dialogic.start("intro_five")
		Player.checkpoints["intro_five"] = true
		
	if (!Player.checkpoints["ice_cream"]) and (planet == Globals.PlanetName.ICE_CREAM):
		Dialogic.start("furo_ice_cream")
		Player.checkpoints["ice_cream"] = true


func _initiate_healthbar(health_bar_bar: TextureProgressBar):
	ore_instance.connect("notify_healthbar", Callable(self, "_on_notify_healthbar"))
	ore_instance.connect("enemy_dead", Callable(self, "_enemy_dead"))
	health_bar.visible = true
	health_bar_bar.size = Vector2(screen_size.x * 0.1, 64)
	health_bar_bar.pivot_offset = Vector2(health_bar_bar.size.x * 0.5, health_bar_bar.size.y * 0.5)
	health_bar_bar.position = screen_size * 0.5 - Vector2(health_bar_bar.size.x * 0.5, screen_size.y * 0.3)
	health_bar_bar.max_value = ore_instance.max_health
	health_bar_bar.value = health_bar_bar.max_value


func _enemy_dead() -> void:
	health_bar.visible = false
	if !Player.checkpoints["intro_four"]:
		Dialogic.start("intro_four")
		Player.checkpoints["intro_four"] = true
		
		Dialogic.timeline_ended.connect(_on_dialogic_ended)
		return
	
	if !Player.defeated_ruru and (planet == Globals.PlanetName.ANTIMATTER):
		Dialogic.start("ruru_player_win")
		Player.defeated_ruru = true
		Dialogic.timeline_ended.connect(_ruru_timeline_defeated)
		return
		
	SceneSwitcher.switch_scene("res://scenes/planet_scene.tscn", planet)


func _on_dialogic_ended() -> void:
	SceneSwitcher.switch_scene("res://scenes/planet_scene.tscn", Globals.PlanetName.IRON)


func _ruru_timeline_defeated() -> void:
	SceneSwitcher.switch_scene("res://scenes/planet_scene.tscn", planet)


func _on_notify_healthbar(new_health: float) -> void:
	health_bar.value = new_health
