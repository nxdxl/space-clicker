extends Control
class_name PlanetTemplate

@export var planet_texture: Texture2D
@export var ore_scene: PackedScene
@onready var planet_image: TextureRect = $PlanetImage
@onready var ore_container: CenterContainer = $OreContainer
var ore_instance: Node = null

func _ready() -> void:
	if planet_texture:
		planet_image.texture = planet_texture
		
	if ore_scene:
		ore_instance = ore_scene.instantiate()
		ore_container.add_child(ore_instance)
