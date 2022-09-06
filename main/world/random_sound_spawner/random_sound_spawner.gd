extends Node2D
class_name RandomSoundSpawner

export(Array, Resource) var sounds: Array

export var volume := 0.0
export var rand_pitch_range := 0.0
export var max_distance := 2000
export var auto_start := false
export var persist := false
export var positional := true

# disabled for performance, allows all sounds to be stopped with wipe_sounds()
export var save_sounds := false

var players := []

func _ready() -> void:
	if auto_start:
		play_sound()

func _on_player_complete(player: Node) -> void:
	if save_sounds:
		players.remove(players.find(player))
	player.queue_free()

func play_sound() -> void:
	var sound_player = AudioStreamPlayer2D.new() if positional else AudioStreamPlayer.new()
	sound_player.volume_db = volume + GlobalData.sound_effect_volume
	sound_player.stream = sounds[randi() % len(sounds)]
	
	if positional:
		sound_player.max_distance = max_distance
	
	sound_player.pitch_scale = 1.0 + (2 * randf() * rand_pitch_range) - rand_pitch_range
	
	if persist:
		GlobalInstanceManager.add_node(sound_player)
		sound_player.global_position = global_position
	else:
		add_child(sound_player)
	sound_player.connect("finished", self, "_on_player_complete", [sound_player])
	sound_player.play()
	
	if save_sounds:
		players.append(sound_player)

func wipe_sounds() -> void:
	for player in players:
		_on_player_complete(player)
