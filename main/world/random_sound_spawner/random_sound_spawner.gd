extends Node2D
class_name RandomSoundSpawner

export(Array, Resource) var sounds: Array

export var volume := 0.0
export var rand_pitch_range := 0.0
export var max_distance := 2000
export var auto_start := false

func _ready() -> void:
	if auto_start:
		play_sound()

func play_sound() -> void:
	var sound_player := AudioStreamPlayer2D.new()
	sound_player.volume_db = volume + GlobalData.sound_effect_volume
	sound_player.stream = sounds[randi() % len(sounds)]
	sound_player.max_distance = max_distance
	
	sound_player.pitch_scale = 1.0 + (2 * randf() * rand_pitch_range) - rand_pitch_range
	
	add_child(sound_player)
	sound_player.play()
