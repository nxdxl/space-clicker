extends Button

const HOVER_SCALE := 1.1
const SCALE_TIME := 0.15

var base_scale := Vector2(1, 1)  # to be set before ready


func _ready():
	scale = base_scale
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)


func _on_mouse_entered():
	var tween = create_tween()
	pivot_offset = Vector2(size.x * 0.5, size.y * 0.5)
	tween.tween_property(self, "scale", base_scale * HOVER_SCALE, SCALE_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_mouse_exited():
	var tween = create_tween()
	pivot_offset = Vector2(size.x * 0.5, size.y * 0.5)
	tween.tween_property(self, "scale", base_scale, SCALE_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
