extends Control

signal close_credits


func _ready() -> void:
	visible = true


func _on_button_pressed() -> void:
	close_credits.emit()
