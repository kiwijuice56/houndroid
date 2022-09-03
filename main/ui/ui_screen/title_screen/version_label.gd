extends Label
class_name VersionLabel

func _ready() -> void:
	text = ProjectSettings.get("application/config/version")
