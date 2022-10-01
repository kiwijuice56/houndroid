extends Area2D
class_name Goal

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area: Area2D) -> void:
	LevelManager.end_level()
