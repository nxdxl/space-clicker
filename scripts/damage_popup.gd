extends Control

@onready var label = $Label
@onready var animation = $AnimationPlayer

func show_damage(text: String):
	
	label.text = text
	visible = true
	animation.play("main_animation")
