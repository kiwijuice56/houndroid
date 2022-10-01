extends Node2D
class_name GameWorld
# Manages all gameplay nodes (excluding spawned nodes), including levels and the player

export var player_scene: PackedScene
export var current_level_scene: PackedScene
export(Array, Resource) var levels: Array

signal level_loaded
signal level_unloaded

# Must already be child at game start
var player: Node 
var current_level: Level

func load_level(index := -1) -> void:
	# Spawn the level indicated or the last level played if none is specified
	if index != -1:
		current_level_scene = levels[index]
	
	# Delete the current instance first
	if is_instance_valid(current_level):
		remove_child(current_level)
		current_level.queue_free()
	
	current_level = current_level_scene.instance()
	add_child(current_level)
	move_child(current_level, 0)
	
	# Reset level and node state
	GlobalInstanceManager.clear_nodes()
	GlobalData.coin_count = 0
	GlobalData.score = 0
	
	# Create a new player scene and position it in the level according to the checkpoint collection status
	if is_instance_valid(player):
		player.queue_free()
	player = player_scene.instance()
	add_child(player)
	
	# A checkpoint_index of -1 is the default index if the player has not reached a checkpoint yet
	if GlobalData.checkpoint_index < 0 or GlobalData.checkpoint_index >= current_level.checkpoints.get_child_count():
		player.global_position = current_level.spawn.global_position
	else:
		# Mark the checkpoint as visited without playing animations
		current_level.checkpoints.get_child(GlobalData.checkpoint_index).enter_checkpoint(true)
		player.global_position = current_level.checkpoints.get_child(GlobalData.checkpoint_index).global_position
	
	# Freeze the player to stop them from moving until the UI is transitioned
	player.frozen = true
	call_deferred("emit_signal", "level_loaded")

func unload_level() -> void:
	# Reset checkpoint only after the level is complete, as resetting it earlier would delete player progress
	GlobalData.checkpoint_index = -1
	current_level.queue_free()
	player.queue_free()
	emit_signal("level_unloaded")

func lock_player() -> void:
	if player != null:
		player.frozen = true

func unlock_player() -> void:
	if player != null:
		player.frozen = false
