extends Node

const Globals = preload("res://scripts/globals.gd")
const SAVE_PATH = "user://save_data.tres"
const SaveDataScript = preload("res://scripts/save_data.gd")

var health: int = 10
var damage: int = 1
# since you can't export Dict[type, type], gotta keep this loosely
# supposed to be Dictionary[Globals.PlanetName, int]
var ore_dictionary: Dictionary = {}
var item_list: Array[ItemData]
var shop_items: Array[ItemData]
# total amount of clicks the player has performed on an ore/enemy
# why did i just not have time to implement this wtf
var total_clicks: int = 0
var total_time_spent: float = 0
var space_dollars: int = 10
var session_start_time: float = 0
var session_save_time: float = 0

# these are checks for certain events in the game
var defeated_ruru = false
var checkpoints: Dictionary[String, bool] = {
	"intro_one": false,
	"intro_two": false,
	"intro_three": false,
	"intro_four": false,
	"intro_five": false,
	"intro_six": false,
	"intro_seven": false,
	"intro_eight": false,
	"ice_cream": false,
	"exotic_matter": false,
	"anti_matter": false,
	"sleep": false
}


func _ready() -> void:
	var auto_save_timer := Timer.new()
	auto_save_timer.wait_time = 60  # Save every 60 seconds
	auto_save_timer.autostart = true
	auto_save_timer.timeout.connect(_save_state)
	add_child(auto_save_timer)


func _save_state() -> void:
	# don't save in the main menu
	if get_tree().current_scene.name == "MainMenu":
		return
	var save_data := SaveDataScript.new()
	save_data.health = health
	save_data.damage = damage
	save_data.ore_dictionary = ore_dictionary
	for item in item_list:
		save_data.item_list.append(item)
	for item in shop_items:
		save_data.shop_items.append(item)
	save_data.total_clicks = total_clicks
	save_data.total_time_spent = total_time_spent
	save_data.space_dollars = space_dollars
	save_data.checkpoints = checkpoints
	save_data.defeated_ruru = defeated_ruru

	var err = ResourceSaver.save(save_data, SAVE_PATH)
	if err == OK:
		print("Game saved.")
	else:
		print("Failed to save! Error code:", err)


func _load_state() -> int:
	if not ResourceLoader.exists(SAVE_PATH):
		print("No save file found.")
		return 1
	
	var loaded = ResourceLoader.load(SAVE_PATH) as SaveDataScript
	if loaded:
		health = loaded.health
		damage = loaded.damage
		ore_dictionary = loaded.ore_dictionary
		for item in loaded.item_list:
			item_list.append(item)
		for item in loaded.shop_items:
			shop_items.append(item)
		total_clicks = loaded.total_clicks
		total_time_spent = loaded.total_time_spent
		space_dollars = loaded.space_dollars
		checkpoints = loaded.checkpoints
		defeated_ruru = loaded.defeated_ruru
		print("Game loaded.")
		return 0
	else:
		print("Failed to load save data.")
		return 1


# auto-save on quit
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("Auto-saving before quit")
		_save_state()
