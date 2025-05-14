extends Control

signal closed_popup

@onready var title = $%PopUpTitle
@onready var icon = $%PopUpIcon
@onready var margin_container = $MarginContainer/MarginContainer
@onready var vbox = $MarginContainer/MarginContainer/VBoxContainer
@onready var text_box = $MarginContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/RichTextLabel
@onready var popup_animation = $PopUpAnimation

var warning_icon = preload("res://img/ui/popup/warning_icon_red.png")
var info_icon = preload("res://img/ui/popup/info_icon_yellow.png")


func show_popup(mode: InfoPopupManager.Mode, text: String) -> void:
	visible = true
	_update_layout()
	match mode:
		InfoPopupManager.Mode.INFO:
			set_title("Info")
			set_icon(info_icon)
		InfoPopupManager.Mode.WARNING:
			set_title("Warning")
			set_icon(warning_icon)
	set_text(text)
	popup_animation.play("pop_up_animation")


func _update_layout() -> void:
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
	print_debug("UPDATING LAYOUT: pivot: %s base res %s base mar %s dyn mar %s mar %s" % [pivot_offset, base_resolution, base_margins, dynamic_margins, margins])


func _on_button_pressed() -> void:
	$PopDownAnimation.play("pop_down_animation")
	await $PopDownAnimation.animation_finished
	emit_signal("closed_popup")
	visible = false


func set_title(t: String) -> void:
	title.text = t


func set_icon(i: Texture2D) -> void:
	icon.texture = i


func set_text(t: String) -> void:
	text_box.text = t
	text_box.size.y = vbox.size.y * 0.8
