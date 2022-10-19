extends Node2D
class_name GameWorld
# Manages all gameplay nodes (excluding spawned nodes), including levels and the player

export var player_scene: PackedScene
export var current_level_scene: PackedScene
export(Array, Resource) var levels: Array

# Store permanent data for all levels
var level_data := {}

# Store temporary data as playing a level
var temp_saved_level_state := {}
var level_state := {}

signal level_loaded
signal level_unloaded

signal coin_count_updated(coin_count)
signal score_updated(score)

var player: Node 
var current_level: Level
var current_level_idx: int = -1

# Loads level data and prepares the scene
func load_level(index := -1) -> void:
	# Spawn the level indicated or the last level played if none is specified
	# We only completely reset data when we are starting a new level 
	if index != -1:
		current_level_idx = index
		current_level_scene = levels[index]
		delete_level_state()
	
	# Delete the current instance first
	if is_instance_valid(current_level):
		remove_child(current_level)
		current_level.queue_free()
	current_level = current_level_scene.instance()
	if current_level.game_name in level_data:
		# We need to mark coins that were already collected as "ghosts"
		current_level.mark_collected_coins(level_data[current_level.game_name]["coins"])
	# But we have to delete coins collected since the level started to prevent them from collecting twice
	current_level.remove_collected_coins(level_state["recently_collected"])
	
	add_child(current_level)
	move_child(current_level, 0)
	
	# Create a new player scene and position it in the level according to the checkpoint collection status
	if is_instance_valid(player):
		player.queue_free()
	player = player_scene.instance()
	add_child(player)
	
	# A checkpoint_index of -1 is the default index if the player has not reached a checkpoint yet
	if not "checkpoint" in level_state or level_state.checkpoint == -1:
		player.global_position = current_level.spawn.global_position
	else:
		# Mark the checkpoint as visited without playing animations
		current_level.checkpoints.get_child(level_state.checkpoint).enter_checkpoint(true)
		player.global_position = current_level.checkpoints.get_child(level_state.checkpoint).global_position
	
	# Freeze the player to stop them from moving until the UI is transitioned
	player.frozen = true
	call_deferred("emit_signal", "level_loaded")

func unload_level() -> void:
	GlobalInstanceManager.clear_nodes()
	current_level.queue_free()
	player.queue_free()
	call_deferred("emit_signal", "level_unloaded")

# Functions used to manage the level state
func set_level_state(key: String, data) -> void:
	level_state[key] = data
	if key == "total_coin_count":
		emit_signal("coin_count_updated", level_state["total_coin_count"])
	if key == "score":
		emit_signal("score_updated", level_state["score"])

func add_to_level_state(key: String, data) -> void:
	set_level_state(key, level_state[key] + data)

func get_level_state(key: String):
	return level_state[key]

func cache_level_state() -> void:
	level_state["time"] = GlobalData.ui_manager.get_screen("GameOverlay").time_label.get_elapsed()
	temp_saved_level_state = level_state.duplicate(true)

func revert_level_state() -> void:
	GlobalData.ui_manager.get_screen("GameOverlay").time_label.elapsed = level_state["time"]
	for key in temp_saved_level_state:
		set_level_state(key, temp_saved_level_state[key])

func delete_level_state() -> void:
	level_state = {}
	
	level_state["checkpoint"] = -1
	level_state["new_coin_count"] = 0
	level_state["total_coin_count"] = 0
	level_state["score"] = 0
	level_state["experience"] = 0
	level_state["time"] = 0
	level_state["recently_collected"] = {}
	
	temp_saved_level_state = level_state.duplicate(true)

# Save the level state into permament storage, such as what coins were collected
func store_user_properties() -> void:
	GlobalData.coin_count += level_state["new_coin_count"]
	GlobalData.experience += level_state["experience"]
	
	if not current_level.game_name in level_data:
		level_data[current_level.game_name] = {}
	
	var level_storage = level_data[current_level.game_name]
	
	if len(level_storage) == 0:
		level_storage["total_coin_count"] = 0
		level_storage["score"] = 0
		level_storage["coins"] = level_state.recently_collected.duplicate()
		level_storage["time"] = 99999999999999
	
	level_storage["index"] = current_level_idx
	
	for path in level_state.recently_collected:
			level_storage["coins"][path] = true 
	
	level_storage["time"] = min(level_storage["time"], GlobalData.ui_manager.get_screen("GameOverlay").time_label.stop())
	level_storage["score"] = max(level_storage["score"], level_state.score)
	level_storage["total_coin_count"] = max(level_storage["total_coin_count"], level_state.total_coin_count)


func lock_player() -> void:
	if player != null:
		player.frozen = true

func unlock_player() -> void:
	if player != null:
		player.frozen = false


# Called whenever a level ends, so this is where we will also manage storing level data into temp storage
func save_file(data: Dictionary) -> void:
	if not is_instance_valid(current_level):
		return
	if not levels in data:
		data["levels"] = {}
	
	data["levels"][current_level.game_name] = level_data[current_level.game_name]

# Called at the start of the game
func load_file(data: Dictionary) -> void:
	if levels in data:
		level_data = data["levels"]
