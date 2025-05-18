extends MarginContainer

const HOVER_SCALE := 1.1
const SCALE_TIME := 0.15

@onready var icon_image: TextureRect = $%HListItemIcon
@onready var item_text: RichTextLabel = $%HListItemText

var icon: Texture2D
var text: String
var title: Titles.Title = -1


func _ready() -> void:
	if icon:
		icon_image.texture = icon
	else:
		icon_image.visible = false
	item_text.text = text
	
	# at first, i checked `if not title: return` and it didn't work and i couldn't figure
	# out why for the life of me, until i realized... the first entry in an enum
	# is just the integer 0, and `not 0` evals to true -> returning too early...
	if title == -1:
		return
	
	item_text.mouse_filter = Control.MOUSE_FILTER_PASS
	item_text.pivot_offset = Vector2(item_text.size.x * 0.5, item_text.size.y * 0.5)
	item_text.gui_input.connect(_on_label_input)
	item_text.connect("mouse_entered", _mouse_entered)
	item_text.connect("mouse_exited", _mouse_exited)


func _on_label_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
			return
		if title not in Player.available_titles:
			UI.warning_notification("You haven't unlocked that yet.")
			return
		Player.player_title = text.split("\n")[0]
		UI.refresh_player_title()


func _mouse_entered():
	var tween = create_tween()
	item_text.pivot_offset = Vector2(item_text.size.x * 0.5, item_text.size.y * 0.5)
	tween.tween_property(self, "scale", Vector2.ONE * HOVER_SCALE, SCALE_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _mouse_exited():
	var tween = create_tween()
	item_text.pivot_offset = Vector2(item_text.size.x * 0.5, item_text.size.y * 0.5)
	tween.tween_property(self, "scale", Vector2.ONE, SCALE_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
