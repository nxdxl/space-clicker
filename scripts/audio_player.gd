extends Node


enum Sound {
	UI_ERROR,
	BUTTON_CLICK,
	UPGRADE
}


var audio_sources: Dictionary[Sound, Resource] = {
	Sound.UI_ERROR: preload("res://audio/ui/error.ogg"),
	Sound.BUTTON_CLICK: preload("res://audio/ui/button_click.ogg"),
	Sound.UPGRADE: preload("res://audio/ui/upgrade.ogg")
}


func play_sound(source: Sound) -> void:
	var player = AudioStreamPlayer.new()
	player.stream = audio_sources[source]
	get_tree().current_scene.add_child(player)
	player.play()
	
	await player.finished
	player.queue_free()
