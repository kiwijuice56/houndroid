extends Node2D
class_name Level

export var game_name := "Level"

onready var spawn: Position2D = $PlayerSpawn
onready var goal: Area2D = $Goal
onready var checkpoints: Node2D = $Checkpoints

onready var init_music_volume: float = $MusicPlayer.volume_db

func _ready() -> void:
	$DeathFallTile.visible = false
	
	GlobalData.connect("music_volume_updated", self, "_on_music_volume_updated")

func _on_music_volume_updated(new_volume: float) -> void:
	$MusicPlayer.volume_db = init_music_volume + new_volume

func mark_collected_coins(coin_data: Dictionary) -> void:
	for path in coin_data:
		$Collectibles.get_node(path).mark_collected()

func remove_collected_coins(coin_data: Dictionary) -> void:
	for path in coin_data:
		$Collectibles.get_node(path).queue_free()
