extends Node

func start_level(index := -1) -> void:
	GlobalData.world.load_level(index)
	yield(GlobalData.world, "level_loaded")
	GlobalData.ui_manager.get_screen("LevelStart").start_introduction()
	yield(GlobalData.ui_manager.get_screen("LevelStart"), "introduction_finished")
	GlobalData.ui_manager.transition("LevelStart", "GameOverlay")
	GlobalData.world.unlock_player()

func reset_level() -> void:
	Transition.trans_in()
	yield(Transition, "finished")
	GlobalData.world.load_level(-1)
	
	GlobalData.ui_manager.transition("GameOverlay", "LevelStart")
	yield(GlobalData.ui_manager, "transition_complete")
	GlobalData.ui_manager.get_screen("LevelStart").start_introduction()
	yield(GlobalData.ui_manager.get_screen("LevelStart"), "introduction_finished")
	
	
	
	GlobalData.ui_manager.transition("LevelStart", "GameOverlay")
	GlobalData.world.unlock_player()
