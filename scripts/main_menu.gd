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
	"Welcome!\nThanks for playing! This Game is not nearly finished, but I hope you enjoy.",
	"The following game contains limited amounts of AI art, due to me being FRKN BROKE. If you are absolutely against that, please close the game.",
	"Unfortunately, furo and I were unable to record our voice lines in time, and I also didn't have time for localization.",
	"That being said, the amazing Ruru did manage to record hers!",
	"I haven't really put much effort into balancing the game yet, so at some point you will find the godmode-key 'G' helpful. It will give you all the resources. (Only works on the bridge)",
	"ENOUGH YAPPING, ENJOY THE GAME (OR WHAT I HAVE SO FAR)"
]


func _ready() -> void:
	credits.visible = false
	bgm.play()
	screen_size = get_viewport_rect().size
	if not ResourceLoader.exists(SAVE_PATH):
		InfoPopupManager.show_info(messages[0])
		InfoPopupManager.connect("pass_popup_closed", Callable(_open_next))
		counter += 1


func _on_new_game_button_pressed() -> void:
	for item in Item.get_item_list():
		Player.item_list.append(item)
		Player.shop_items.append(item)
		
	for ore in Globals.PlanetName.values():
		Player.ore_dictionary[ore] = 0
	
	# switch to bridge
	SceneSwitcher.switch_scene(bridge_scene)


func _open_next() -> void:
	if counter < messages.size():
		await get_tree().create_timer(1).timeout
		if counter == 1:
			InfoPopupManager.show_warning(messages[counter])
		else:
			InfoPopupManager.show_info(messages[counter])
		counter += 1


func _on_quit_game_button_pressed() -> void:
	get_tree().quit(0)


func _on_continue_button_pressed() -> void:
	if not ResourceLoader.exists(SAVE_PATH):
		InfoPopupManager.show_warning("You don't have a save file. Please start a new game.")
		return
	Player._load_state()
	SceneSwitcher.switch_scene(bridge_scene)


func _on_credits_button_pressed() -> void:
	credits.visible = true


func _on_language_pressed() -> void:
	InfoPopupManager.show_warning("Didn't I just say I didn't implement localization?")
