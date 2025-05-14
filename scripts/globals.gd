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
		# i hate myself
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

static var planet_animation_nodes: Dictionary[PlanetName, NodePath] = {
	PlanetName.ANTIMATTER: "res://scenes/planets/antimatter_blackhole.tscn",
	PlanetName.DIAMOND: "res://scenes/planets/diamond_planet.tscn",
	PlanetName.EXOTIC_MATTER: "res://scenes/planets/exotic_matter_galaxy.tscn",
	PlanetName.ICE_CREAM: "res://scenes/planets/ice_cream_planet.tscn",
	PlanetName.IRON: "res://scenes/planets/iron_planet.tscn",
	PlanetName.MAGMA: "res://scenes/planets/magma_planet.tscn",
	PlanetName.OBSIDIAN: "res://scenes/planets/obsidian_planet.tscn",
	PlanetName.PLATINUM: "res://scenes/planets/platinum_planet.tscn",
	PlanetName.STARDUST: "res://scenes/planets/stardust_planet.tscn",
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

static var planet_scenes: Dictionary[PlanetName, NodePath] = {
	PlanetName.ANTIMATTER: "res://scenes/planets/antimatter_blackhole_main.tscn",
	PlanetName.DIAMOND: "res://scenes/planets/diamond_planet_main.tscn",
	PlanetName.EXOTIC_MATTER: "res://scenes/planets/exotic_matter_galaxy_main.tscn",
	PlanetName.ICE_CREAM: "res://scenes/planets/ice_cream_planet_main.tscn",
	PlanetName.IRON: "res://scenes/planets/iron_planet_main.tscn",
	PlanetName.MAGMA: "res://scenes/planets/magma_planet_main.tscn",
	PlanetName.OBSIDIAN: "res://scenes/planets/obsidian_planet_main.tscn",
	PlanetName.PLATINUM: "res://scenes/planets/platinum_planet_main.tscn",
	PlanetName.STARDUST: "res://scenes/planets/stardust_planet_main.tscn",
}
