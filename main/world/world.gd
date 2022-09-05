extends Node2D
class_name GameWorld

export var player_scene: PackedScene
export var current_level_scene: PackedScene

signal level_loaded

# Must already be child at game start
var player: Node 
var current_level: Level

func load_level() -> void:
	Transition.trans_in()
	yield(Transition, "finished")
	
	if current_level != null:
		remove_child(current_level)
		current_level.queue_free()
	current_level = current_level_scene.instance()
	add_child(current_level)
	move_child(current_level, 0)
	
	GlobalInstanceManager.clear_nodes()
	
	GlobalData.coin_count = 0
	GlobalData.score = 0
	
	if player != null:
		player.queue_free()
	player = player_scene.instance()
	player.game_world = self
	add_child(player)
	player.global_position = current_level.spawn.global_position
	player.frozen = true
	
	Transition.trans_out()
	yield(Transition, "finished")
	
	player.frozen = false
	
	emit_signal("level_loaded")
