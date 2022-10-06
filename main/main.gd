extends Node
class_name Main
# The root scene script
# Allows for starting levels when the game is opened for quick debugging 
# Note that the UI state may be glitched in quick start

export var quick_start := false

func _ready() -> void:
	randomize()
	if quick_start:
		LevelManager.reset_level()
	GlobalData.file_loader.load_file(0)
