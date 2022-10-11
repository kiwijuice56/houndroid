extends Node
# Global node for managing player and save data
# Bad practice, but convenience of having access to data in all places is worth it

signal coin_count_updated(coin_count)
signal score_updated(score)
signal music_volume_updated(volume)

# Reference variables for ease of access to most world and UI top nodes
onready var world: GameWorld = get_tree().get_root().get_node("Main/World")
onready var ui_manager: UIScreenManager = get_tree().get_root().get_node("Main/UIScreenManager")
onready var file_loader: FileLoader = get_tree().get_root().get_node("Main/FileLoader")

# Option variables
var sound_effect_volume := 0.0
var music_volume := 0.0 setget set_music_volume

# Player currency variables
var coin_count := 0 
var experience := 0 
var items := {}

func _ready() -> void:
	add_to_group("Save")

func set_music_volume(new_volume: float) -> void:
	music_volume = new_volume
	emit_signal("music_volume_updated", music_volume)

func save_file(data: Dictionary) -> void:
	data["coin_count"] = coin_count
	data["experience"] = experience
	data["options"] = {}
	data["options"]["sound_effect_volume"] = sound_effect_volume
	data["options"]["music_volume"] = music_volume
	data["items"] = items

func load_file(data: Dictionary) -> void:
	coin_count = data["coin_count"]
	experience = data["experience"]
	
	sound_effect_volume = data["options"]["sound_effect_volume"]
	music_volume = data["options"]["music_volume"]
	items = data["items"]
