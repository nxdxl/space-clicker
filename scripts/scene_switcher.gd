extends Node

var current_scene = null


func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)


func switch_scene(res_path: String, data = null):
	call_deferred("_deferred_switch_scene", res_path, data)


func _deferred_switch_scene(res_path: String, data):
	current_scene.free()
	var scene = load(res_path)
	
	current_scene = scene.instantiate()
	
	if data != null and current_scene.has_method("init"):
		current_scene.init(data)
	
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	if current_scene.name == "Navi":
		# i couldn't get this to work otherwise
		UI._hide_ui()
		UI.modular_back_button.visible = true
	elif current_scene.name == "MainMenu":
		UI._hide_ui()
	else:
		UI._show_ui()
