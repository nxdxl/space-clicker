extends Node

const SAVE_PATH = "user://space_clicker_save_data.tres"
const SaveDataScript = preload("res://scripts/save_data.gd")
const Globals = preload("res://scripts/globals.gd")

var player_name: String
var player_title: String
var available_titles: Array[Titles.Title]
var max_health: int
var health: int
var damage: int
var ore_dictionary: Dictionary
var item_list: Array[ItemData]
var shop_items: Array[ItemData]
var total_clicks: int
var total_time_spent: float
var space_dollars: int
var total_space_dollars: int
var session_start_time: float
var achievements: Array[Achievements.Achievement]
var hidden_achievements: Array[Achievements.HiddenAchievement]
var rank: Ranks.Rank

# these are checks for certain events in the game
var defeated_ruru: bool
var checkpoints: Dictionary[String, bool]


func _ready() -> void:
	var auto_save_timer := Timer.new()
	session_start_time = Time.get_unix_time_from_system()
	auto_save_timer.wait_time = 60  # Save every 60 seconds
	auto_save_timer.autostart = true
	auto_save_timer.timeout.connect(_save_state)
	add_child(auto_save_timer)


func instantiate_new_player() -> void:	
	player_name = "[   ]" # default
	player_title = ""
	available_titles = []
	max_health = 10
	health = 10
	damage = 1
	for ore in Globals.PlanetName.values():
		ore_dictionary[ore] = 0
	for item in Item.get_item_list():
		item_list.append(item)
		shop_items.append(item)
	total_clicks = 0
	total_time_spent = 0
	space_dollars = 10
	achievements = []
	hidden_achievements = []
	rank = -1
	defeated_ruru = false
	checkpoints = {
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
	_save_state()


func achieve(achievement: Achievements.Achievement = Achievements.Achievement.DUMMY, hidden: Achievements.HiddenAchievement = Achievements.HiddenAchievement.DUMMY) -> void:
	if achievement != Achievements.Achievement.DUMMY:
		achievements.append(achievement)
		# since we only go off of achievements for the ranks, this is fine
		UI.notify(Achievements.achievement_image, "New Achievement Unlocked", Achievements.achievement_names[achievement])
		check_and_do_rank_upgrade()
	if hidden != Achievements.HiddenAchievement.DUMMY:
		hidden_achievements.append(hidden)


func unlock_title(title: Titles.Title) -> void:
	Player.available_titles.append(title)


func has_achieved(achievement: Achievements.Achievement = Achievements.Achievement.DUMMY, hidden: Achievements.HiddenAchievement = Achievements.HiddenAchievement.DUMMY) -> bool:
	# check if player has achieved a certain achievement
	if achievement != Achievements.Achievement.DUMMY:
		return achievement in achievements
	return hidden in hidden_achievements


func check_and_do_rank_upgrade() -> void:
	# i do this, so that it checks if we achieve multiple ranks at once
	# should only happen in god mode tho
	while Ranks.check_rank_reqs(Player.rank + 1):
		Player.rank += 1
		UI.notify(Ranks.rank_images[Player.rank], "New Rank Unlocked", Ranks.rank_names[Player.rank])
		UI.refresh_player_rank()


func add_space_dollars(amount: int) -> void:
	Player.space_dollars += amount
	Player.total_space_dollars += amount
	
	for achvmnt in Achievements.req_space_dollars.keys():
		if not achvmnt in Player.achievements:
			if Player.total_space_dollars >= Achievements.req_space_dollars[achvmnt]:
				Player.achieve(achvmnt)


func add_click(clicks: int = 1) -> void:
	Player.total_clicks += clicks
	UI.refresh_side_bar()
	
	# so we don't check for the achievement every single click
	if Player.total_clicks % 100 == 0:
		_check_click_achievement()


func _check_click_achievement():
	for achvmnt in Achievements.req_clicks.keys():
		if achvmnt not in Player.achievements:
			if Player.total_clicks >= Achievements.req_clicks[achvmnt]:
				Player.achieve(achvmnt)


func _save_state() -> void:
	# don't save in the main menu
	if get_tree().current_scene.name == "MainMenu":
		return
	if (total_time_spent >= 60 * 10) and not (Achievements.Achievement.NEWCOMER in Player.achievements):
		achieve(Achievements.Achievement.NEWCOMER)
	if (total_time_spent >= 60 * 60) and not (Achievements.Achievement.KNOWN in Player.achievements):
		achieve(Achievements.Achievement.KNOWN)
	if (total_time_spent >= 60 * 600) and not (Achievements.Achievement.HOW in Player.achievements):
		achieve(Achievements.Achievement.HOW)
	var save_data := SaveDataScript.new()
	save_data.player_name = player_name
	save_data.player_title = player_title
	save_data.max_health = max_health
	save_data.health = health
	save_data.damage = damage
	save_data.ore_dictionary = ore_dictionary
	for item in item_list:
		save_data.item_list.append(item)
	for item in shop_items:
		save_data.shop_items.append(item)
	for achievement in achievements:
		save_data.achievements.append(achievement)
	for hidden in hidden_achievements:
		save_data.hidden_achievements.append(hidden)
	for title in available_titles:
		save_data.available_titles.append(title)
	save_data.total_clicks = total_clicks
	save_data.space_dollars = space_dollars
	save_data.checkpoints = checkpoints
	save_data.defeated_ruru = defeated_ruru
	total_time_spent += (Time.get_unix_time_from_system() - session_start_time)
	save_data.total_time_spent = total_time_spent
	save_data.total_space_dollars = total_space_dollars
	save_data.rank = rank
	
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
		player_name = loaded.player_name
		player_title = loaded.player_title
		max_health = loaded.max_health
		health = loaded.health
		damage = loaded.damage
		ore_dictionary = loaded.ore_dictionary
		for item in loaded.item_list:
			item_list.append(item)
		for item in loaded.shop_items:
			shop_items.append(item)
		for achievement in loaded.achievements:
			achievements.append(achievement)
		for hidden in loaded.hidden_achievements:
			hidden_achievements.append(hidden)
		for title in loaded.available_titles:
			available_titles.append(title)
		total_clicks = loaded.total_clicks
		total_time_spent = loaded.total_time_spent
		space_dollars = loaded.space_dollars
		checkpoints = loaded.checkpoints
		defeated_ruru = loaded.defeated_ruru
		total_space_dollars = loaded.total_space_dollars
		rank = loaded.rank
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
