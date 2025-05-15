extends Area2D

signal notify_healthbar(new_health: int)
signal enemy_dead
signal create_ruru
signal kill_bgm

const Globals = preload("res://scripts/globals.gd")

@onready var sprite = $EnemySprite
@onready var EXPLOOOOOOSIOOOOOON = $Explosion # sorry, this variable NEEDS to be called this way. IDC ABOUT STYLE GUIDELINES
@onready var audio = $Explosion/AudioStreamPlayer2D

var max_health: int
var current_health: int
var attack: int
var space_dollars: int
var target_scene: String
var planet: Globals.PlanetName
var screen_size: Vector2
var dead = false


func _ready() -> void:
	screen_size = get_viewport_rect().size
	EXPLOOOOOOSIOOOOOON.visible = false
	position = screen_size * 0.5
	connect("input_event", Callable(self, "_on_input_event"))


func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		_on_click()


func _show_popup_text(text: String):
	var dmg_scene = preload("res://scenes/damage_pop_up.tscn")
	var dmg_text = dmg_scene.instantiate()
	get_tree().root.add_child(dmg_text)
	
	dmg_text.show_damage(text)


func _on_click() -> void:
	current_health -= Player.damage
	if current_health <= 0 and not dead:
		dead = true
		emit_signal("kill_bgm")
		_defeat_enemy()
	
	emit_signal("notify_healthbar", current_health)
	if not dead:
		Player.add_click()
		_show_popup_text("%s" % Player.damage)


func _defeat_enemy() -> void:
	Player.add_space_dollars(space_dollars)
	EXPLOOOOOOSIOOOOOON.visible = true
	EXPLOOOOOOSIOOOOOON.play("main_animation")
	audio.play()
	audio.connect("finished", Callable(self, "_on_audio_finished"))


func set_stats(planet_: Globals.PlanetName) -> void:
	planet = planet_
	if !(planet_ == Globals.PlanetName.ANTIMATTER):
		max_health = _calculate_health()
		current_health = max_health
		attack = (Player.health / randi() % 20) + 1
		space_dollars = Ores.max_health_by_type[planet] / 10 + Player.damage
		sprite.texture = enemey_textures()[randi() % 8]
		return
	
	if (!Player.defeated_ruru and (planet_ == Globals.PlanetName.ANTIMATTER)):
		Dialogic.start("ruru_encounter")
		Dialogic.timeline_ended.connect(_spawn_ruru)
	else:
		SceneSwitcher.switch_scene("res://scenes/planet_scene.tscn", planet)


func _spawn_ruru() -> void:
	max_health = 100
	current_health = max_health
	attack = Player.health * 0.1
	space_dollars = 0
	sprite.texture = preload("res://img/characters/ruru/ruru_default.png")
	emit_signal("create_ruru")


func _calculate_health() -> int:
	var component_one = Player.health
	var component_two = Player.damage
	var component_three = 0.5 if !Player.checkpoints["intro_seven"] else 1
	var component_four = 2 if Player.defeated_ruru else 1.5
	var component_five = 0
	for item in Player.item_list:
		component_five += item.level
	if component_five == 0:
		component_five = 0.5
	
	# i have absolutely no idea if any of this makes any sense xD we'll see
	return (component_one + component_two) * (component_three + component_four + component_five)


func enemey_textures() -> Array[Texture2D]:
	var sprites: Array[Texture2D]
	sprites.append(preload("res://img/characters/enemies/girl_1.png"))
	sprites.append(preload("res://img/characters/enemies/girl_2.png"))
	sprites.append(preload("res://img/characters/enemies/girl_3.png"))
	sprites.append(preload("res://img/characters/enemies/girl_4.png"))
	sprites.append(preload("res://img/characters/enemies/girl_5.png"))
	sprites.append(preload("res://img/characters/enemies/girl_6.png"))
	sprites.append(preload("res://img/characters/enemies/girl_7.png"))
	sprites.append(preload("res://img/characters/enemies/girl_8.png"))
	return sprites 


func _on_explosion_animation_finished() -> void:
	EXPLOOOOOOSIOOOOOON.visible = false


func _on_audio_finished() -> void:
	emit_signal("enemy_dead")
	queue_free()
