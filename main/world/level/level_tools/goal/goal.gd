extends Area2D
class_name Goal

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area: Area2D) -> void:
	GlobalData.ui_manager.transition("GameOverlay", "LevelFinish")
	yield(GlobalData.ui_manager, "transition_complete")
	GlobalData.ui_manager.transition("LevelFinish", "LevelSelect")
