extends UIScreen
class_name DebugScreen

func _ready() -> void:
	yield(get_parent().get_parent(), "ready")
	for child in ui_manager.get_children():
		if not child is CanvasLayer:
			return
		var screen: UIScreen = child.get_child(0)
		var label: Label = Label.new()
		$VBoxContainer.add_child(label)
		label.name = screen.name
		screen.connect("input_changed", self, "_on_input_changed")
		_on_input_changed(screen, screen.input_disabled)

func _on_input_changed(screen: UIScreen, input_disabled: bool) -> void:
	var label: Label = $VBoxContainer.get_node(screen.name)
	if input_disabled:
		label.add_color_override("font_color", Color(255, 0, 0))
	else:
		label.add_color_override("font_color", Color(0, 128, 255))
	label.text = "    " + screen.name

func _input(event) -> void:
	if event.is_action_pressed("debug"):
		visible = !visible

