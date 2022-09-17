extends Node
class_name Main

export var quick_start := false

func _ready() -> void:
	randomize()
	if quick_start:
		LevelManager.reset_level()
