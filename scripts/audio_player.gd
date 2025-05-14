extends Node


enum Sound {
	UIError,
	ButtonClick,
	Upgrade
}


var audio_sources: Dictionary[Sound, Resource] = {
	Sound.UIError: preload("res://audio/ui/error.ogg"),
	Sound.ButtonClick: preload("res://audio/ui/button_click.ogg"),
	Sound.Upgrade: preload("res://audio/ui/upgrade.ogg")
}


func play_sound(source: Sound) -> void:
	var player = AudioStreamPlayer.new()
	player.stream = audio_sources[source]
	get_tree().current_scene.add_child(player)
	player.play()
	
	await player.finished
	player.queue_free()
