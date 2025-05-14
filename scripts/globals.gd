# i found out you could do global shit like this way too late...
extends Control

# this should have probably been ore names, well, whatever
enum PlanetName {
	ANTIMATTER,
	DIAMOND,
	EXOTIC_MATTER,
	ICE_CREAM,
	IRON,
	MAGMA,
	OBSIDIAN,
	PLATINUM,
	STARDUST,
}


enum PlanetType {
	PLANET,
	OTHER,
}


static var planet_requirements: Dictionary[PlanetName, Dictionary] = {
	PlanetName.ANTIMATTER: {
		Item.ItemName.ENGINE: 3
	},
	PlanetName.DIAMOND: {
		Item.ItemName.ENGINE: 1
	},
	PlanetName.EXOTIC_MATTER: {
		Item.ItemName.METEORITE_SHIELD: 1,
		Item.ItemName.ENGINE: 2
	},
	PlanetName.ICE_CREAM: {
		Item.ItemName.METEORITE_SHIELD: 1,
		# and also defeat ruru, but i can't handle that in here, sigh
	},
	PlanetName.IRON: {
		Item.ItemName.ENGINE: 0
	},
	PlanetName.MAGMA: {
		Item.ItemName.METEORITE_SHIELD: 1,
		Item.ItemName.ENGINE: 1
	},
	PlanetName.OBSIDIAN: {
		Item.ItemName.ENGINE: 1
	},
	PlanetName.PLATINUM: {
		Item.ItemName.METEORITE_SHIELD: 1
	},
	PlanetName.STARDUST: {
		Item.ItemName.METEORITE_SHIELD: 1,
		Item.ItemName.ENGINE: 2,
	},
}

static var mining_requirements: Dictionary[PlanetName, Dictionary] = {
	PlanetName.ANTIMATTER: {
		Item.ItemName.BUCKET: 2
	},
	PlanetName.DIAMOND: {
		Item.ItemName.PICKAXE: 1
	},
	PlanetName.EXOTIC_MATTER: {
		Item.ItemName.BUCKET: 1
	},
	PlanetName.ICE_CREAM: {
		Item.ItemName.MAGMA_SPOON: 1
	},
	PlanetName.IRON: {
		Item.ItemName.ENGINE: 0
	},
	PlanetName.MAGMA: {
		Item.ItemName.MAGMA_SPOON: 1
	},
	PlanetName.OBSIDIAN: {
		Item.ItemName.PICKAXE: 2
	},
	PlanetName.PLATINUM: {
		Item.ItemName.PICKAXE: 2
	},
	PlanetName.STARDUST: {
		Item.ItemName.BUCKET: 1
	},
}

static var planet_animation_nodes: Dictionary[PlanetName, Resource] = {
	PlanetName.ANTIMATTER: preload("res://scenes/planets/antimatter_blackhole.tscn"),
	PlanetName.DIAMOND: preload("res://scenes/planets/diamond_planet.tscn"),
	PlanetName.EXOTIC_MATTER: preload("res://scenes/planets/exotic_matter_galaxy.tscn"),
	PlanetName.ICE_CREAM: preload("res://scenes/planets/ice_cream_planet.tscn"),
	PlanetName.IRON: preload("res://scenes/planets/iron_planet.tscn"),
	PlanetName.MAGMA: preload("res://scenes/planets/magma_planet.tscn"),
	PlanetName.OBSIDIAN: preload("res://scenes/planets/obsidian_planet.tscn"),
	PlanetName.PLATINUM: preload("res://scenes/planets/platinum_planet.tscn"),
	PlanetName.STARDUST: preload("res://scenes/planets/stardust_planet.tscn"),
}

static var planet_types: Dictionary[PlanetName, PlanetType] = {
	PlanetName.ANTIMATTER: PlanetType.OTHER,
	PlanetName.DIAMOND: PlanetType.PLANET,
	PlanetName.EXOTIC_MATTER: PlanetType.OTHER,
	PlanetName.ICE_CREAM: PlanetType.PLANET,
	PlanetName.IRON: PlanetType.PLANET,
	PlanetName.MAGMA: PlanetType.PLANET,
	PlanetName.OBSIDIAN: PlanetType.PLANET,
	PlanetName.PLATINUM: PlanetType.OTHER,
	PlanetName.STARDUST: PlanetType.PLANET,
}

static var planet_background_textures: Dictionary[PlanetName, Texture2D] = {
	PlanetName.ANTIMATTER: preload("res://img/backgrounds/antimatter_background.png"),
	PlanetName.DIAMOND: preload("res://img/backgrounds/diamond_planet_background.png"),
	PlanetName.EXOTIC_MATTER: preload("res://img/backgrounds/exotic_matter_galaxy_background.png"),
	PlanetName.ICE_CREAM: preload("res://img/backgrounds/ice_cream_planet_background.png"),
	PlanetName.IRON: preload("res://img/backgrounds/iron_planet_background.png"),
	PlanetName.MAGMA: preload("res://img/backgrounds/magma_planet_background.png"),
	PlanetName.OBSIDIAN: preload("res://img/backgrounds/obsidian_planet_background.png"),
	PlanetName.PLATINUM: preload("res://img/backgrounds/platinum_planet_background.png"),
	PlanetName.STARDUST: preload("res://img/backgrounds/stardust_planet_background.png"),
}
