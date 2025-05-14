extends Node
class_name Item

const Globals = preload("res://scripts/globals.gd")

# these are variables, not funtions! no need for 2 lines in between :relieved:
static var item_textures = {
	ItemName.PICKAXE: preload("res://img/items/pick_axe_texture.png"),
	ItemName.METEORITE_SHIELD: preload("res://img/items/meteorite_shield_texture.png"),
	ItemName.ENGINE: preload("res://img/items/engine_texture.png"),
	ItemName.BUCKET: preload("res://img/items/bucket_texture.png"),
	ItemName.MAGMA_SPOON: preload("res://img/items/magma_spoon_texture.png")
}

static var item_names = {
	ItemName.PICKAXE: {
		0: "Pickaxe",
		1: "Iron Pickaxe",
		2: "Diamond Pickaxe"
	},
	ItemName.METEORITE_SHIELD: {
		0: "Meteorite Shield",
		1: "Meteorite Shield"
	},
	ItemName.ENGINE: {
		0: "Engine",
		1: "Better Engine",
		2: "Exotic Engine",
		3: "Stardust Engine"
	},
	ItemName.BUCKET: {
		0: "Bucket",
		1: "Bucket",
		2: "Exotic Bucket",
		3: "Stardust Bucket"
	},
	ItemName.MAGMA_SPOON: {
		0: "Magma Spoon",
		1: "Magma Spoon"
	}
}

static var item_prices = {
	ItemName.PICKAXE: 10,
	ItemName.METEORITE_SHIELD: 100,
	ItemName.ENGINE: 10,
	ItemName.BUCKET: 1000,
	ItemName.MAGMA_SPOON: 1000
}

static var item_upgrade_materials = {
	ItemName.PICKAXE: {
		1: {
			Globals.PlanetName.IRON: 10,
			Globals.PlanetName.DIAMOND: 10
		}
	},
	ItemName.ENGINE: {
		# Engine -> BetterEngine
		0: {
			Globals.PlanetName.IRON: 1
		},
		# BetterEngine -> ExoticEngine
		1: {
			Globals.PlanetName.IRON: 100,
			Globals.PlanetName.DIAMOND: 100,
			Globals.PlanetName.OBSIDIAN: 100,
			Globals.PlanetName.MAGMA: 100,
		},
		# ExoticEngine -> StardustEngine
		2: {
			Globals.PlanetName.OBSIDIAN: 1000,
			Globals.PlanetName.MAGMA: 1000,
			Globals.PlanetName.EXOTIC_MATTER: 100
		}
	},
	ItemName.BUCKET: {
		# Bucket -> ExoticBucket
		1: {
			Globals.PlanetName.OBSIDIAN: 1000,
			Globals.PlanetName.EXOTIC_MATTER: 100
		},
		# ExoticBucket -> StardustBucket
		2: {
			Globals.PlanetName.EXOTIC_MATTER: 1000,
			Globals.PlanetName.STARDUST: 100
		},
	},
	ItemName.METEORITE_SHIELD: {
		1: {
		},
	},
	ItemName.MAGMA_SPOON: {
		1: {
		},
	},
}

static var item_upgrade_costs = {
	ItemName.PICKAXE: {
		# Iron -> Diamond
		1: 10,
	},
	ItemName.METEORITE_SHIELD: {
		1: 0,
	},
	ItemName.MAGMA_SPOON: {
		1: 0,
	},
	ItemName.ENGINE: {
		# Engine -> BetterEngine
		0: 10,
		# BetterEngine -> ExoticEngine
		1: 1000,
		# ExoticEngine -> StardustEngine
		# RANDOM NUMBERS GO BRRRRRR
		2: 10000
	},
	ItemName.BUCKET: {
		# Bucket -> ExoticBucket
		1: 1000,
		# ExoticBucket -> StardustBucket
		2: 10000
	}
}

static var item_max_levels = {
	ItemName.PICKAXE: 2,
	ItemName.METEORITE_SHIELD: 1,
	ItemName.ENGINE: 3,
	ItemName.BUCKET: 3,
	ItemName.MAGMA_SPOON: 1
}


enum ItemName {
	PICKAXE,
	METEORITE_SHIELD,
	ENGINE,
	BUCKET,
	MAGMA_SPOON,
}


static func _instantiate_item_by_type(item_name: ItemName) -> ItemData:
	var item_data = ItemData.new()
	item_data.level = 0
	item_data.item_name = item_names[item_name][item_data.level]
	item_data.item_type = item_name
	item_data.texture = item_textures[item_name]
	item_data.price = item_prices[item_name]
	item_data.purchased = false
	item_data.upgrade_materials = item_upgrade_materials[item_name]
	item_data.upgrade_cost = item_upgrade_costs[item_name]
	item_data.max_level = item_max_levels[item_name]
	
	return item_data


static func get_item_list() -> Array[ItemData]:
	var item_list: Array[ItemData]
	for item_name in ItemName:
		var item = get_item(item_name)
		var item_data = _instantiate_item_by_type(item)
		item_list.append(item_data)
		
	return item_list


static func is_unlocked(item: ItemData) -> bool:
	if item.item_type == Item.ItemName.ENGINE:
		return true
	return item.level > 0


static func is_purchaseable(item: ItemData) -> bool:
	return Player.space_dollars >= item.price


static func upgrade(item: ItemData) -> void:
	for req in item.upgrade_materials[item.level]:
		Player.ore_dictionary[req] -= item.upgrade_materials[item.level][req]
	match item.item_type:
		Item.ItemName.PICKAXE:
			apply_pickaxe_upgrade()
		Item.ItemName.BUCKET:
			apply_bucket_upgrade()
	Player.space_dollars -= item.upgrade_cost[item.level]
	item.level += 1
	item.item_name = item_names[item.item_type][item.level]


static func apply_pickaxe_upgrade():
	# This is absolutely random, but it's an upgrade
	Player.damage = (Player.damage + 10) * 3.5


static func apply_bucket_upgrade():
	Player.damage = Player.damage * 2
	Player.health += 100


static func is_upgradeable(item: ItemData) -> bool:
	if is_max_level(item):
		return false
	if Player.space_dollars < item.upgrade_cost[item.level]:
		return false
	for req in item.upgrade_materials[item.level]:
		if Player.ore_dictionary[req] < item.upgrade_materials[item.level][req]:
			return false
	return true


static func is_max_level(item: ItemData) -> bool:
	return item.level == item_max_levels[item.item_type]


static func get_item(name_string: String) -> ItemName:
	match name_string:
		"PICKAXE":
			return ItemName.PICKAXE
		"METEORITE_SHIELD":
			return ItemName.METEORITE_SHIELD
		"ENGINE":
			return ItemName.ENGINE
		"BUCKET":
			return ItemName.BUCKET
		"MAGMA_SPOON":
			return ItemName.MAGMA_SPOON
	
	# i don't really have a default...
	return ItemName.PICKAXE
