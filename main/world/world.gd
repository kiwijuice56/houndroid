extends Node2D
class_name GameWorld

export var player_scene: PackedScene
export var current_level_scene: PackedScene
export(Array, Resource) var levels: Array

signal level_loaded
signal level_unloaded

# Must already be child at game start
var player: Node 
var current_level: Level

func load_level(index := -1) -> void:
	if index != -1:
		current_level_scene = levels[index]
	
	if is_instance_valid(current_level):
		remove_child(current_level)
		current_level.queue_free()
	
	current_level = current_level_scene.instance()
	add_child(current_level)
	move_child(current_level, 0)
	
	GlobalInstanceManager.clear_nodes()
	
	GlobalData.coin_count = 0
	GlobalData.score = 0
	
	if is_instance_valid(player):
		player.queue_free()
		
	player = player_scene.instance()
	add_child(player)
	
	player.global_position = current_level.spawn.global_position
	player.frozen = true
	
	call_deferred("emit_signal", "level_loaded")

func unload_level() -> void:
	current_level.queue_free()
	player.queue_free()
	emit_signal("level_unloaded")

func lock_player() -> void:
	if player != null:
		player.frozen = true

func unlock_player() -> void:
	if player != null:
		player.frozen = false
