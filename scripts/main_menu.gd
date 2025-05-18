extends Control

const SAVE_PATH = "user://space_clicker_save_data.tres"
const SaveDataScript = preload("res://scripts/save_data.gd")
const Globals = preload("res://scripts/globals.gd")

@onready var bgm = $BGM
@onready var credits = $Credits
@onready var animation = $Credits/PopDownAnimation
@onready var ok_button = $%OKButton
@onready var input_panel = $PlayerNameInputPanel
@onready var player_name_input = $%PlayerNameInput
@onready var fade_animation = $%FadeAnimation
@onready var music_animation = $%MusicFadeAnimation
@onready var name_animation = $%PlayerNameAnimation

var bridge_scene = "res://scenes/bridge.tscn"
var counter = 0
var screen_size: Vector2
var messages = [
	"The following game contains limited amounts of AI art, due to me being FRKN BROKE. If you are absolutely against that, please close the game."
]


func _ready() -> void:
	UI._hide_ui()
	input_panel.scale = Vector2.ZERO
	credits.visible = false
	credits.connect("close_credits", _on_credits_close)
	bgm.play()
	screen_size = get_viewport_rect().size
	if not ResourceLoader.exists(SAVE_PATH):
		InfoPopupManager.show_warning(messages[0])
		InfoPopupManager.connect("pass_popup_closed", Callable(_open_next))
		counter += 1


func _on_new_game_button_pressed() -> void:
	Player.instantiate_new_player()
	fade_animation.play("main_animation")
	music_animation.play("main_animation")
	await fade_animation.animation_finished
	await music_animation.animation_finished
	name_animation.play("main_animation")
	input_panel.visible = true


func _open_next() -> void:
	if counter < messages.size():
		await get_tree().create_timer(0.7).timeout
		InfoPopupManager.show_info(messages[counter])
		counter += 1


func _on_quit_game_button_pressed() -> void:
	get_tree().quit(0)


func _on_continue_button_pressed() -> void:
	if not ResourceLoader.exists(SAVE_PATH):
		UI.warning_notification("You don't have a save file.")
		return
	Player._load_state()
	SceneSwitcher.switch_scene(bridge_scene)


func _on_credits_button_pressed() -> void:
	credits.visible = true
	credits.scale = Vector2.ZERO
	credits.get_child(1).play("main_animation")
	await credits.get_child(1).animation_finished


func _on_credits_close() -> void:
	credits.get_child(1).play_backwards("main_animation")
	await credits.get_child(1).animation_finished
	credits.visible = false


func _on_language_pressed() -> void:
	UI.warning_notification("Not implemented yet!")


func _on_ok_button_pressed() -> void:
	Player.player_name = player_name_input.text
	if Player.player_name.length() > 17:
		Player.player_name = Player.player_name.substr(0, 16)
	if Player.player_name.length() == 0:
		Player.player_name = "[   ]"
	SceneSwitcher.switch_scene(bridge_scene)


func _on_player_name_input_text_submitted(new_text: String) -> void:
	_on_ok_button_pressed()
