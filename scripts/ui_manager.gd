extends CanvasLayer

const Globals = preload("res://scripts/globals.gd")

var popup_open = false

# --------- #
# Player UI #
# --------- #
@onready var player_info_box 		= $%PlayerInfoBox
@onready var player_stats 			= $%PlayerStats
@onready var hide_show_ui 			= $%HideShowUI
@onready var side_bar 				= $%PlayerItemList
@onready var player_title 			= $%Title
@onready var player_name 			= $%PlayerName
@onready var health_bar 			= $%HealthBar
@onready var player_rank 			= $%PlayerRank

# ------------- #
# Notifications #
# ------------- #
@onready var notification_panel 	= $%NotificationPanel
@onready var notification_image 	= $%NotificationImage
@onready var upper_label 			= $%UpperLabel
@onready var lower_label 			= $%LowerLabel
@onready var notification_animation = $%NotificationAnimation
var notification_open: bool 		= false
var warning: bool 					= false

# ---------- #
# Namazon UI #
# ---------- #
@onready var namazon 				= $UI/NamazonPanel
@onready var namazon_close 			= $UI/NamazonPanel/LargePopUpCloseButton
@onready var namazon_animation 		= $UI/NamazonPanel/LargePopUpAnimation
@onready var namazon_icon			= $UI/NamazonPanel/IconHolder/LargePopUpIcon
@onready var namazon_text			= $UI/NamazonPanel/LargePopUpTitle
var namazon_buy_flow 				= null
var namazon_sell_flow				= null
var namazon_tab						= preload("res://scenes/tab.tscn")
var namazon_item_scene 				= preload("res://scenes/namazon_item.tscn")
var namazon_tab_container			= preload("res://scenes/large_pop_up_tab_container.tscn")
var namazon_icon_texture			= preload("res://img/ui/bridge/namazon.png")

# ----------- #
# Workshop UI #
# ----------- #
@onready var workshop				= $UI/WorkshopPanel
@onready var workshop_close 		= $UI/WorkshopPanel/LargePopUpCloseButton
@onready var workshop_animation 	= $UI/WorkshopPanel/LargePopUpAnimation
@onready var workshop_icon			= $UI/WorkshopPanel/IconHolder/LargePopUpIcon
@onready var workshop_text			= $UI/WorkshopPanel/LargePopUpTitle
var workshop_item_scene				= preload("res://scenes/workshop_item.tscn")
var workshop_icon_texture			= preload("res://img/ui/bridge/workshop.png")

# ------------------- #
# Modular Back Button #
# ------------------- #
@onready var modular_back_button	= $UI/ModularBackButton
var last_scene: String 				= ""

# ------------ #
# Menu Buttons #
# ------------ #
@onready var menu_button_panel 		= $%MenuButtonPanel
@onready var quit_button			= $%QuitButton
@onready var achievement_button		= $%AchievementButton
@onready var sleep_button			= $%SleepButton
@onready var workshop_button		= $%WorkshopButton
@onready var navi_button			= $%NaviButton
@onready var namazon_button			= $%NamazonButton
var navi_scene_path: NodePath 		= "res://scenes/navi.tscn"

# ----------------------------- #
# Achievements & Ranks & Titles #
# ----------------------------- #
@onready var achvmnt_rank_panel 	= $%AchvmntRankPanel
@onready var achvmnt_box 			= $%AchvmntVBox
@onready var rank_box 				= $%RankVBox
@onready var title_box				= $%TitleVBox
@onready var rank_animation_player 	= $%RankAnimationPlayer
var hlist_item 						= preload("res://scenes/h_list_item.tscn")
var achvmnt_icon 					= preload("res://img/ranks/achievement.png")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("god_mode"):
		if get_tree().current_scene.name == "MainMenu":
			return
		var achvmnt = Achievements.Achievement.GODMODE
		if not achvmnt in Player.achievements:
			Player.achieve(achvmnt)
		Player.damage = 10000
		Player.add_space_dollars(10000000)
		Player.add_click(10000000)
		Player._check_click_achievement()
		Player.total_time_spent = 10000000
		for ore in Player.ore_dictionary:
			Player.ore_dictionary[ore] = 10000000
		Player._save_state()
		UI.refresh_side_bar()
		UI.refresh_player_rank()
		if namazon.visible:
			_refresh_namazon_items()


func _ready() -> void:
	Dialogic.timeline_started.connect(_hide_ui)
	Dialogic.timeline_ended.connect(_show_ui)
	namazon.connect("large_popup_closed", Callable(close_popup))
	workshop.connect("large_popup_closed", Callable(close_popup))


func ui_is_visible() -> bool:
	return player_info_box.visible


func _hide_ui() -> void:
	player_info_box.visible = false
	player_stats.visible = false
	hide_show_ui.visible = false
	namazon.visible = false
	workshop.visible = false
	modular_back_button.visible = false
	menu_button_panel.visible = false


func _show_ui() -> void:
	# forcefully suppress ui in the navi
	if get_tree().current_scene.name == "Navi":
		return
	modular_back_button.visible = true
	player_info_box.visible = true
	player_stats.visible = true
	hide_show_ui.visible = true
	menu_button_panel.visible = true


func notify(image: Texture2D, upper: String, lower: String) -> void:
	# not gonna lie, i'm kinda proud of this, this is so cool haha
	while notification_open:
		await get_tree().create_timer(1).timeout
	notification_panel.visible = true
	notification_open = true
	notification_image.texture = image
	upper_label.text = upper
	lower_label.text = lower
	notification_animation.play("pop_in")
	await get_tree().create_timer(2.5).timeout
	notification_animation.play_backwards("pop_in")
	notification_open = false


func warning_notification(text: String):
	var image = preload("res://img/ui/popup/warning_icon_red.png")
	AudioPlayer.play_sound(AudioPlayer.Sound.UI_ERROR)
	notify(image, "WARNING!", text)


func info_notification(text: String):
	var image = preload("res://img/ui/popup/info_icon_yellow.png")
	AudioPlayer.play_sound(AudioPlayer.Sound.BUTTON_CLICK)
	notify(image, "INFO!", text)


func open_workshop() -> void:
	if popup_open:
		return
	popup_open = true
	_prepare_workshop()
	refresh_side_bar()
	workshop_icon.texture = workshop_icon_texture
	workshop_text.text = "WORKSHOP"
	workshop.visible = true
	workshop_animation.play("main_animation")


func _prepare_workshop() -> void:
	if workshop.get_child_count() > 4:
		return
	var margin_container: MarginContainer = MarginContainer.new()
	margin_container.anchor_left = 0
	margin_container.anchor_top = 0
	var scroll_container: ScrollContainer = ScrollContainer.new()
	margin_container.size = Vector2(1126, 620)
	margin_container.position = Vector2(11, 139)
	scroll_container.position = Vector2(11, 139)
	scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin_container.add_theme_constant_override("margin_left", 100)
	margin_container.add_theme_constant_override("margin_right", 100)
	margin_container.add_theme_constant_override("margin_top", 10)
	var hflow_container: HFlowContainer = HFlowContainer.new()
	hflow_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hflow_container.add_theme_constant_override("h_separation", 310)
	hflow_container.add_theme_constant_override("v_separation", 310)
	hflow_container.position = Vector2(11, 139)
	scroll_container.add_child(hflow_container)
	margin_container.add_child(scroll_container)
	workshop.add_child(margin_container)
	_add_workshop_items(hflow_container)


func _add_workshop_items(hflow_container: HFlowContainer) -> void:
	for item in Player.item_list:
		if Item.is_unlocked(item):
			var list_item = workshop_item_scene.instantiate()
			list_item.connect("item_upgraded", Callable(self, "_redraw_workshop_items").bind(hflow_container))
			var item_size = list_item.get_child(0).size.x
			list_item.item = item
			hflow_container.add_theme_constant_override("h_separation", item_size + 10)
			hflow_container.add_theme_constant_override("v_separation", item_size + 10)
			hflow_container.add_child(list_item)


func _redraw_workshop_items(container: HFlowContainer):
	refresh_side_bar()
	for item in container.get_children():
		item._ready()
	if !Player.checkpoints["intro_eight"]:
		Dialogic.timeline_ended.disconnect(show_upgrade_popup)
		Dialogic.start("intro_eight")
		Player.checkpoints["intro_eight"] = true
		Player.achieve(Achievements.Achievement.USELESS_UPGRADE)
		UI.popup_open = false # i close it with this...


func show_upgrade_popup() -> void:
	InfoPopupManager.show_info("With the just mined ore, you can now upgrade your ship! What does the upgrade do you ask? Well, don't ask!")


func open_namazon() -> void:
	if popup_open:
		return
	popup_open = true
	if namazon.get_child_count() != 5:
		_add_tabs()
		_add_namazon_items()
	_refresh_namazon_items()
	namazon_icon.texture = namazon_icon_texture
	namazon_text.text = "NAMAZON"
	namazon.visible = true
	namazon_animation.play("main_animation")


func _add_tabs() -> void:
	var instance = namazon_tab_container.instantiate()
	# for some god forsaken reason, there is a margin container that i never add
	# so i gotta set the position manually...
	var buy_tab = namazon_tab.instantiate()
	buy_tab.name = "BUY"
	var sell_tab = namazon_tab.instantiate()
	sell_tab.name = "SELL"
	instance.add_child(buy_tab)
	instance.add_child(sell_tab)
	namazon_buy_flow = buy_tab.get_child(0).get_child(0)
	namazon.add_child(instance)


func _add_namazon_items() -> void:
	for item in Player.shop_items:
		if item.item_type == Item.get_item("ENGINE"):
			continue
		var list_item = namazon_item_scene.instantiate()
		list_item.connect("item_purchased", Callable(self, "_on_namazon_item_purchased"))
		var item_size = list_item.get_child(0).size.x
		list_item.item = item
		namazon_buy_flow.add_theme_constant_override("h_separation", item_size + 10)
		namazon_buy_flow.add_theme_constant_override("v_separation", item_size + 10)
		namazon_buy_flow.add_child(list_item)
		
	# add dummy items to make namazon scrollable
	for i in range(3):
		var item = namazon_item_scene.instantiate()
		var item_panel_container: PanelContainer = item.get_child(0)
		item_panel_container.get_child(0).add_theme_stylebox_override("panel", StyleBoxEmpty.new())
		item_panel_container.remove_child(item_panel_container.get_child(1))
		namazon_buy_flow.add_child(item)


func _on_namazon_item_purchased() -> void:
	refresh_side_bar()
	_refresh_namazon_items()


func _refresh_namazon_items() -> void:
	for item in namazon_buy_flow.get_children():
		item._ready()


func close_popup(node: Panel) -> void:
	popup_open = false
	var animation = node.get_child(3)
	animation.play_backwards("main_animation")
	await animation.animation_finished
	node.visible = false


func refresh_player() -> void:
	refresh_player_name()
	refresh_player_rank()
	refresh_player_title()


func refresh_player_title() -> void:
	player_title.text = Player.player_title


func refresh_player_name() -> void:
	player_name.text = Player.player_name


func refresh_player_rank() -> void:
	# hacky workarounds :pensive: :pray:
	if Player.rank == -1:
		return
	player_rank.texture = Ranks.rank_images[Player.rank]


func refresh_health_bar(new_health: int) -> void:
	health_bar.value = new_health


func refresh_clicks() -> void:
	side_bar.set_item_text(0, "Total Nr. Clicks: %s" % Player.total_clicks)


func refresh_side_bar() -> void:
	refresh_clicks()
	side_bar.set_item_text(1, "Max. Health: %s" % Player.max_health)
	side_bar.set_item_text(2, "Damage: %s" % Player.damage)
	side_bar.set_item_text(3, "x%s" % Player.space_dollars)
	side_bar.set_item_text(4, "x%s" % Player.ore_dictionary[Globals.PlanetName.IRON])
	side_bar.set_item_text(5, "x%s" % Player.ore_dictionary[Globals.PlanetName.DIAMOND])
	side_bar.set_item_text(6, "x%s" % Player.ore_dictionary[Globals.PlanetName.OBSIDIAN])
	side_bar.set_item_text(7, "x%s" % Player.ore_dictionary[Globals.PlanetName.PLATINUM])
	side_bar.set_item_text(8, "x%s" % Player.ore_dictionary[Globals.PlanetName.MAGMA])
	side_bar.set_item_text(9, "x%s" % Player.ore_dictionary[Globals.PlanetName.EXOTIC_MATTER])
	side_bar.set_item_text(10, "x%s" % Player.ore_dictionary[Globals.PlanetName.STARDUST])
	side_bar.set_item_text(11, "x%s" % Player.ore_dictionary[Globals.PlanetName.ANTIMATTER])


func _on_rank_close_button_pressed() -> void:
	popup_open = false
	for child in achvmnt_box.get_children():
		child.free()
	for child in rank_box.get_children():
		child.free()
	for child in title_box.get_children():
		child.free()
	rank_animation_player.play_backwards("main_animation")
	await rank_animation_player.animation_finished
	achvmnt_rank_panel.visible = false


func _open_achievement_ranks() -> void:
	if popup_open:
		return
	popup_open = true
	achvmnt_rank_panel.visible = true
	rank_animation_player.play("main_animation")
	_add_achievements()
	_add_ranks()
	_add_titles()


func _add_achievements() -> void:
	for achvmnt in Achievements.Achievement:
		if achvmnt == "DUMMY":
			continue
		var item = hlist_item.instantiate()
		var key = Achievements.Achievement.get(achvmnt)
		item.icon = achvmnt_icon
		item.text = Achievements.achievement_names[key] + "\n" + Achievements.achievement_descriptions[key]
		if key not in Player.achievements:
			item.modulate = Color(0.4, 0.4, 0.4, 1)
		achvmnt_box.add_child(item)
	var item = hlist_item.instantiate()
	item.icon = null
	item.text = " And %s remaining hidden achievements!" % (Achievements.HiddenAchievement.size() - 1 - Player.hidden_achievements.size())
	achvmnt_box.add_child(item)


func _add_ranks() -> void:
	for rank in Ranks.Rank:
		var item = hlist_item.instantiate()
		var key = Ranks.Rank.get(rank)
		item.icon = Ranks.rank_images[key]
		var req_text = "Requires: "
		for req in Ranks.rank_reqs[key]:
			req_text += Achievements.achievement_names[req] + ", "
		item.text = Ranks.rank_names[key] + "\n" + req_text.substr(0, req_text.length() - 2)
		if key > Player.rank:
			item.modulate = Color(0.4, 0.4, 0.4, 1)
		rank_box.add_child(item)


func _add_titles() -> void:
	for title in Titles.Title:
		var item = hlist_item.instantiate()
		var key = Titles.Title.get(title)
		item.icon = null
		item.text = Titles.title_names[key] + "\n" + Titles.title_descriptions[key]
		if key not in Player.available_titles:
			item.modulate = Color(0.4, 0.4, 0.4, 1)
		item.title = key
		title_box.add_child(item)


func _on_button_pressed() -> void:
	var btn_size: Vector2 = hide_show_ui.size
	
	if player_info_box.visible:
		_hide_ui()
		hide_show_ui.visible = true
		hide_show_ui.text = "SHOW UI"
		hide_show_ui.pivot_offset = Vector2(btn_size.x, 0)
		hide_show_ui.scale = Vector2.ONE * 0.5
	else:
		_show_ui()
		hide_show_ui.text = "HIDE UI"
		hide_show_ui.pivot_offset = Vector2(btn_size.x, 0)
		hide_show_ui.scale = Vector2.ONE * 1


func _on_modular_back_button_pressed() -> void:
	SceneSwitcher.switch_scene(last_scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit(0)


func _on_achievement_button_pressed() -> void:
	_open_achievement_ranks()
	AudioPlayer.play_sound(AudioPlayer.Sound.BUTTON_CLICK)


func _on_sleep_button_pressed() -> void:
	Player._save_state()
	UI.info_notification("Game Saved")


func _on_workshop_button_pressed() -> void:
	if !Player.checkpoints["intro_six"]:
		warning_notification("You can't do that yet.")
		return
	open_workshop()
	AudioPlayer.play_sound(AudioPlayer.Sound.BUTTON_CLICK)


func _on_navi_button_pressed() -> void:
	SceneSwitcher.switch_scene(navi_scene_path)


func _on_namazon_button_pressed() -> void:
	if !Player.checkpoints["intro_six"] or !Player.checkpoints["intro_eight"]:
		warning_notification("You can't do that yet.")
		return
	open_namazon()
	AudioPlayer.play_sound(AudioPlayer.Sound.BUTTON_CLICK)
