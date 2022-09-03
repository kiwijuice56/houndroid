tool
extends Control
class_name SpritesheetAnimImportDock

signal animation_confirmed(anim_name, start, end, fps, duration)

func _ready() -> void:
	var loop: OptionButton = $Options/Loop/OptionButton
	loop.add_item("None")
	loop.add_item("Linear")
	loop.add_item("Ping-Pong")

func initialize() -> void:
	var confirm_button: Button = $Options/ConfirmButton
	if not confirm_button.is_connected("pressed", self, "_on_confirm_button_pressed"):
		confirm_button.connect("pressed", self, "_on_confirm_button_pressed")

func _on_confirm_button_pressed() -> void:
	var start_frame: SpinBox = $Options/StartFrame/SpinBox
	var end_frame: SpinBox = $Options/EndFrame/SpinBox
	var fps: SpinBox = $Options/FPS/SpinBox
	var duration: SpinBox = $Options/FrameDuration/SpinBox
	var loop: OptionButton = $Options/Loop/OptionButton
	var anim_name: LineEdit = $Options/AnimName/LineEdit
	
	emit_signal("animation_confirmed",
	anim_name.text, start_frame.value, end_frame.value, fps.value, duration.value, loop.selected)
