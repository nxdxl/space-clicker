extends MarginContainer

@onready var icon_image = $%HListItemIcon
@onready var item_text = $%HListItemText

var icon: Texture2D
var text: String

func _ready() -> void:
	icon_image.texture = icon
	item_text.text = text
