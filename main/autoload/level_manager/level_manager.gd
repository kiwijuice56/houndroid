extends Node
# Interface to control level and UI state in a centralized place

# Assumes that the UI state is in LevelSelect
func start_level(index := -1) -> void:
	# Transition from the level select into the preliminary starting sequence
	GlobalData.ui_manager.transition("LevelSelect", "LevelStart")
	yield(GlobalData.ui_manager, "transition_complete")
	
	# Load the level assets
	GlobalData.world.load_level(index)
	yield(GlobalData.world, "level_loaded")
	
	# Play out the full introduction sequence
	GlobalData.ui_manager.get_screen("LevelStart").start_introduction()
	yield(GlobalData.ui_manager.get_screen("LevelStart"), "introduction_finished")
	
	# Transition to gameplay UI and start the player
	GlobalData.ui_manager.transition("LevelStart", "GameOverlay")
	GlobalData.world.unlock_player()

func end_level() -> void:
	# Transition from the level select into the full finish sequence
	GlobalData.ui_manager.transition("GameOverlay", "LevelFinish")
	yield(GlobalData.ui_manager, "transition_complete")
	
	# Transition back into the level select
	GlobalData.ui_manager.transition("LevelFinish", "LevelSelect")
	
	GlobalData.world.unload_level()

# Assumes that the UI state is in GameOverlay
func reset_level() -> void:
	# Block out the screen and reset the level
	Transition.trans_in()
	yield(Transition, "finished")
	GlobalData.world.load_level(-1)
	
	# Transition from the gameplay UI into the preliminary starting sequence
	GlobalData.ui_manager.transition("GameOverlay", "LevelStart")
	yield(GlobalData.ui_manager, "transition_complete")
	
	# Play out the full introduction sequence
	GlobalData.ui_manager.get_screen("LevelStart").start_introduction()
	yield(GlobalData.ui_manager.get_screen("LevelStart"), "introduction_finished")
	
	# Transition to gameplay UI and start the player
	GlobalData.ui_manager.transition("LevelStart", "GameOverlay")
	GlobalData.world.unlock_player()
