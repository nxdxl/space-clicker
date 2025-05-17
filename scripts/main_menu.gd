extends Control

const SAVE_PATH = "user://save_data.tres"
const SaveDataScript = preload("res://scripts/save_data.gd")
const Globals = preload("res://scripts/globals.gd")

@onready var bgm = $BGM
@onready var credits = $Credits
@onready var animation = $Credits/PopDownAnimation

var bridge_scene = "res://scenes/bridge.tscn"
var counter = 0
var screen_size: Vector2
var messages = [
	"The following game contains limited amounts of AI art, due to me being FRKN BROKE. If you are absolutely against that, please close the game."
]


func _ready() -> void:
	UI._hide_ui()
	credits.visible = false
	bgm.play()
	screen_size = get_viewport_rect().size
	if not ResourceLoader.exists(SAVE_PATH):
		InfoPopupManager.show_warning(messages[0])
		InfoPopupManager.connect("pass_popup_closed", Callable(_open_next))
		counter += 1


func _on_new_game_button_pressed() -> void:
	for item in Item.get_item_list():
		Player.item_list.append(item)
		Player.shop_items.append(item)
		
	for ore in Globals.PlanetName.values():
		Player.ore_dictionary[ore] = 0
		
	# show username input popup
	
	# switch to bridge
	SceneSwitcher.switch_scene(bridge_scene)


func _open_next() -> void:
	if counter < messages.size():
		await get_tree().create_timer(1).timeout
		if counter == 0:
			InfoPopupManager.show_warning(messages[counter])
		else:
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


func _on_language_pressed() -> void:
	UI.warning_notification("Not implemented yet!")
