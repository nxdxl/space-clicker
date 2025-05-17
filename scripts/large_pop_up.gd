extends Panel

signal large_popup_closed(node: Panel)


func _on_large_pop_up_close_button_pressed() -> void:
	large_popup_closed.emit(self)
