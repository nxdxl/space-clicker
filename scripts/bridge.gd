extends Control

const BUTTON_SCALE := 0.15  # percent of shorter screen side
const Globals = preload("res://scripts/globals.gd")

@onready var furo_image: TextureRect = $FuroImage
@onready var ruru_image: TextureRect = $RuruImage
@onready var furo_image_animation: AnimationPlayer = $FuroImage/AnimationPlayer
@onready var ruru_image_animation: AnimationPlayer = $RuruImage/AnimationPlayer
@onready var bgm: AudioStreamPlayer2D = $BGM

var screen_size: Vector2
var dynamic_scale: float


func _ready():
	UI.last_scene = "res://scenes/main_menu.tscn"
	UI.modular_back_button.text = "MENU"
	
	furo_image.visible = false
	ruru_image.visible = false
	
	for ore in get_tree().get_nodes_in_group("ores"):
		ore.connect("ore_mined", Callable(self, "_on_ore_mined"))

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
		Dialogic.timeline_ended.connect(UI.show_upgrade_popup)
		
	if Player.checkpoints["intro_eight"]:
		bgm.play()
		character_fade_in(furo_image, furo_image_animation)
		
	if Player.defeated_ruru:
		furo_image.position.x = furo_image.position.x - screen_size.x * 0.1
		character_fade_in(ruru_image, ruru_image_animation)
		
	UI.visible = true
	UI.refresh_side_bar()
	UI.refresh_player_rank()


func character_fade_in(image: TextureRect, anim: AnimationPlayer) -> void:
	image.visible = true
	anim.play("fade_in")


func show_navi_button_popup() -> void:
	InfoPopupManager.show_info("Clicking on the explore button in the middle will take you to the navigation system! Try it out!")
	Player.achieve(Achievements.Achievement.MEET_FURO)


func _open_sleep():
	InfoPopupManager.show_info("Clicking in the top button to sleep will save the game. The gamestate is also saved every 60 seconds.")
	Player.checkpoints["sleep"] = true
