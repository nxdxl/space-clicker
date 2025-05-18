extends Control

signal closed_popup

@onready var title = $%PopUpTitle
@onready var icon = $%PopUpIcon
@onready var text_box = $%RichTextLabel
@onready var close_button = $%PopUpButton
@onready var popup_animation = $PopUpAnimation

var warning_icon = preload("res://img/ui/popup/warning_icon_red.png")
var info_icon = preload("res://img/ui/popup/info_icon_yellow.png")


func show_popup(mode: InfoPopupManager.Mode, text: String) -> void:
	match mode:
		InfoPopupManager.Mode.INFO:
			set_title("INFO")
			set_icon(info_icon)
		InfoPopupManager.Mode.WARNING:
			set_title("WWARNING")
			set_icon(warning_icon)
	set_text(text)
	visible = true
	popup_animation.play("pop_up_animation")


func _on_button_pressed() -> void:
	popup_animation.play_backwards("pop_up_animation")
	await popup_animation.animation_finished
	closed_popup.emit()
	visible = false


func set_title(t: String) -> void:
	title.text = t


func set_icon(i: Texture2D) -> void:
	icon.texture = i


func set_text(t: String) -> void:
	text_box.text = t
