extends Control

@onready var label = $Label
@onready var animation = $AnimationPlayer

func show_damage(text: String):
	
	label.text = text
	visible = true
	animation.play("main_animation")
	#var tween = create_tween()
	#tween.tween_property(self, "position:y", position.y - 100, 0.5).set_trans(Tween.TRANS_SINE)
	#tween.tween_callback(Callable(self, "queue_free"))
