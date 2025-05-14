extends Control

# i tried making this global, but i failed at getting the nodes from the tree fsr :shrug:

static var info_popup = preload("res://scenes/pop_up_window.tscn")
static var warning_popup = preload("res://scenes/pop_up_window.tscn")


static func play_animation(animation_player: AnimationPlayer, animation_name: String) -> void:
	animation_player.play(animation_name)


static func open_info(screen_size: Vector2) -> Control:
	var scene = info_popup.instantiate()
	var pop_up_animation = scene.get_node("PopUpAnimation")
	scene.visible = true
	scene.pivot_offset = Vector2(screen_size.x * 0.5, screen_size.y * 0.5)
	play_animation(pop_up_animation, "pop_up_animation")
	return scene
