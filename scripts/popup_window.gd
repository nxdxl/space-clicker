extends Control

signal open_sleep

@onready var title = $%PopUpTitle
@onready var icon = $%PopUpIcon
@onready var margin_container = $MarginContainer/MarginContainer
@onready var vbox = $MarginContainer/MarginContainer/VBoxContainer
@onready var text_box = $MarginContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/RichTextLabel
@onready var hflow_container = $%HFlowContainer


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
	if !Player.checkpoints["sleep"]:
		get_tree().create_timer(1.5).timeout
		emit_signal("open_sleep")


func set_title(title_string: String) -> void:
	title.text = title_string
	# doing it like this bc i think removing children while iterating over them
	# is undefined behaviour. too lazy to check tho
	var children: Array = []
	for child in hflow_container.get_children():
		children.append(child)
	for child in children:
		hflow_container.remove_child(child)


func set_icon(icon_texture: Texture2D) -> void:
	icon.texture = icon_texture
