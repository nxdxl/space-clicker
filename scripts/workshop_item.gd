extends Control

signal item_upgraded
signal refresh_workshop

const Globals = preload("res://scripts/globals.gd")

@onready var item_image = $%ItemImage
@onready var item_list: ItemList = $%ItemList
@onready var upgrade_button: Button = $%UpgradeButton
@onready var item_name_label = $%ItemName

var item: ItemData


func _ready() -> void:
	item_name_label.text = item.item_name
	item_image.texture = item.texture
	var item_count = item_list.item_count
	for i in range(item_count):
		item_list.remove_item(0)
	var item_name: Item.ItemName = item.item_type
	var current_level: int = item.level
	var required_items: Dictionary = {}
	if !Item.is_max_level(item):
		required_items = Item.item_upgrade_materials[item.item_type][item.level]
		var index = 1
		if _not_spoon_or_shield():
			item_list.add_item("Space Dollars", preload("res://img/currency/coin.png"), false)
			item_list.set_item_tooltip(0, "Space Dollars %s/%s" % [Player.space_dollars, Item.item_upgrade_costs[item_name][item.level]])
			index = 0
		for req_item in required_items:
			item_list.add_item(Ores.ore_type_to_name[req_item], Ores.ore_textures[req_item], false)
			item_list.set_item_tooltip(index + 1, "%s %s/%s" % [Ores.ore_type_to_name[req_item], Player.ore_dictionary[req_item], Item.item_upgrade_materials[item_name][current_level][req_item]])
			index += 1
	upgrade_button.disabled = !Item.is_upgradeable(item)
	if Item.is_max_level(item):
		upgrade_button.text = "MAX"
	upgrade_button.connect("pressed", Callable(self, "_on_upgrade_button_pressed").bind(item))


func _not_spoon_or_shield() -> bool:
	return !(item.item_type == Item.ItemName.MAGMA_SPOON or item.item_type == Item.ItemName.METEORITE_SHIELD)


func _on_upgrade_button_pressed(item_data: ItemData) -> void:
	Item.upgrade(item_data)
	UI.refresh_side_bar()
	# THIS IS THE UPGRADED STATE #
	# -------------------------- #
	#        ACHIEVEMENTS        #
	# -------------------------- #
	
	if (item_data.item_type == Item.ItemName.ENGINE) and (item_data.level == 2):
		Player.achieve(Achievements.Achievement.AN_EVEN_BETTER_ENGINE)
		
	if (item_data.item_type == Item.ItemName.ENGINE) and (item_data.level == 3):
		Player.achieve(Achievements.Achievement.THE_BEST_ENGINE)
	
	AudioPlayer.play_sound(AudioPlayer.Sound.UPGRADE)
	emit_signal("item_upgraded")
	emit_signal("refresh_workshop")
