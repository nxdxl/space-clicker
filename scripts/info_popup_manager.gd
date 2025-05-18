extends Control

signal pass_popup_closed

var popup_scene = preload("res://scenes/info_pop_up.tscn")
var popup_instance: Node = null


enum Mode {
	INFO,
	WARNING
}


func show_warning(text: String):
	AudioPlayer.play_sound(AudioPlayer.Sound.UI_ERROR)
	_show_popup(Mode.WARNING, text)


func show_info(text: String):
	_show_popup(Mode.INFO, text)


func _show_popup(mode: Mode, text: String):
	if popup_instance:
		popup_instance.show_popup(mode, text)
		return
	popup_instance = popup_scene.instantiate()
	get_tree().current_scene.add_child(popup_instance)
	popup_instance.show_popup(mode, text)
	popup_instance.connect("closed_popup", Callable(_on_popup_closed))


func _on_popup_closed() -> void:
	emit_signal("pass_popup_closed")
