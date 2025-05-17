extends Control

const Globals = preload("res://scripts/globals.gd")

@onready var health_bar = $%HealthBar
@onready var center = $CenterContainer
@onready var fight_bgm = $AudioStreamPlayer2D
@onready var ruru_bgm = $RuruBossBGM

var enemy_scene = preload("res://scenes/enemy.tscn")
var enemy_instance = enemy_scene.instantiate()
var target_planet: Globals.PlanetName
var screen_size: Vector2


func init(planet) -> void:
	target_planet = planet


func _ready() -> void:
	UI.last_scene = "res://scenes/navi.tscn"
	UI.modular_back_button.text = "FLEE"
	
	screen_size = get_viewport_rect().size
	center.add_child(enemy_instance)
	enemy_instance.connect("create_ruru", Callable(_handle_ruru_creation))
	enemy_instance.connect("kill_bgm", Callable(_kill_bgm))
	enemy_instance.set_stats(target_planet)
	if !(target_planet == Globals.PlanetName.ANTIMATTER):
		fight_bgm.play()
		_initiate_healthbar(health_bar)
		
	if !Player.checkpoints["intro_three"]:
		Dialogic.start("intro_three")
		Player.checkpoints["intro_three"] = true
		Dialogic.timeline_ended.connect(handle_enemy_info)


func _kill_bgm() -> void:
	if target_planet == Globals.PlanetName.ANTIMATTER:
		ruru_bgm.stop()
	else:
		fight_bgm.stop()


func handle_enemy_info() -> void:
	InfoPopupManager.show_info("Click on the enemy until it dies. If you're too slow, it might destroy your satellite ship. (dying isn't implemented yet)")


func _initiate_healthbar(health_bar_bar: TextureProgressBar):
	enemy_instance.connect("notify_healthbar", Callable(self, "_on_notify_healthbar"))
	enemy_instance.connect("enemy_dead", Callable(self, "_enemy_dead"))
	health_bar.visible = true
	health_bar_bar.size = Vector2(screen_size.x * 0.1, 64)
	health_bar_bar.pivot_offset = Vector2(health_bar_bar.size.x * 0.5, health_bar_bar.size.y * 0.5)
	health_bar_bar.position = screen_size * 0.5 - Vector2(health_bar_bar.size.x * 0.5, screen_size.y * 0.3)
	health_bar_bar.max_value = enemy_instance.max_health
	health_bar_bar.value = health_bar_bar.max_value


func _enemy_dead() -> void:
	health_bar.visible = false
	UI.refresh_side_bar()
	if !Player.checkpoints["intro_four"]:
		Dialogic.start("intro_four")
		Player.checkpoints["intro_four"] = true
		
		Dialogic.timeline_ended.connect(_on_dialogic_ended)
		return
	
	if !Player.defeated_ruru and (target_planet == Globals.PlanetName.ANTIMATTER):
		Dialogic.start("ruru_player_win")
		Player.achieve(Achievements.Achievement.THE_FALLEN_ANGEL)
		Player.defeated_ruru = true
		Dialogic.timeline_ended.connect(_ruru_timeline_defeated)
		return
	
	SceneSwitcher.switch_scene("res://scenes/planet_scene.tscn", target_planet)


func _on_dialogic_ended() -> void:
	SceneSwitcher.switch_scene("res://scenes/planet_scene.tscn", Globals.PlanetName.IRON)


func _ruru_timeline_defeated() -> void:
	SceneSwitcher.switch_scene("res://scenes/planet_scene.tscn", Globals.PlanetName.ANTIMATTER)


func _on_notify_healthbar(new_health: float) -> void:
	health_bar.value = new_health


func _on_button_pressed() -> void:
	SceneSwitcher.switch_scene("res://scenes/navi.tscn")


func _handle_ruru_creation() -> void:
	_initiate_healthbar(health_bar)
	ruru_bgm.play()
