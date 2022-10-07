extends Button
class_name SoundButton

func _ready() -> void:
	connect("button_down", self, "_on_pressed")
	connect("button_up", self, "_on_released")

func _on_pressed() -> void:
	$ButtonSounds/PressSounds.play_sound()

func _on_released() -> void:
	$ButtonSounds/ReleaseSounds.play_sound()
