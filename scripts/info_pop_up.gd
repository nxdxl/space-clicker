extends Control

signal closed_popup

@onready var title = $%PopUpTitle
@onready var icon = $%PopUpIcon
@onready var margin_container = $MarginContainer/MarginContainer
@onready var vbox = $MarginContainer/MarginContainer/VBoxContainer
@onready var text_box = $MarginContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/RichTextLabel


func _ready() -> void:
	visible = false
	var screen_size = get_viewport_rect().size
	pivot_offset = screen_size * 0.5
	var base_resolution = Vector2(1920, 1080)
	var base_margins = Vector2(750, 340)
	var dynamic_margins = base_resolution / base_margins
	var margins = screen_size * dynamic_margins
	vbox.add_theme_constant_override("separation", 20)
	margin_container.add_theme_constant_override("margin_left", margins.x)
	margin_container.add_theme_constant_override("margin_right", margins.x)
	margin_container.add_theme_constant_override("margin_top", margins.y)
	margin_container.add_theme_constant_override("margin_bottom", margins.y)


func _on_button_pressed() -> void:
	# i just wanna mention that i am a naming GOD
	$PopDownAnimation.play("pop_down_animation")
	emit_signal("closed_popup")


func set_title(title_string: String) -> void:
	title.text = title_string


func set_icon(icon_texture: Texture2D) -> void:
	icon.texture = icon_texture


func set_text(text: String) -> void:
	text_box.text = text
	var vbsizey = vbox.size.y
	text_box.size.y = vbsizey * 0.8
