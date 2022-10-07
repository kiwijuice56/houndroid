extends Label
class_name FpsLabel

func _ready() -> void:
	$Timer.connect("timeout", self, "_on_update_timeout")

func _on_update_timeout() -> void:
	text = "FPS " + str(Engine.get_frames_per_second())
