extends Label
class_name FpsLabel

func _process(_delta) -> void:
	text = "FPS " + str(Engine.get_frames_per_second())
