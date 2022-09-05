extends UIScreen
class_name TitleScreen

export var button_container_path: NodePath
export var corner_button_container_path: NodePath
var button_container: Container
var corner_button_container: Container

func _ready() -> void:
	button_container = get_node(button_container_path)
	corner_button_container = get_node(corner_button_container_path)
	for button in button_container.get_children() + corner_button_container.get_children():
		if not button is Button:
			continue
		button.connect("pressed", self, "_on_button_pressed", [button.name])

func _on_button_pressed(name: String) -> void:
	match name:
		"Start":
			GlobalData.world.load_level()
			ui_manager.transition("TitleScreen", "GameOverlay")

func transition_to(to: String) -> void:
	match to:
		"GameOverlay":
			visible = false
	call_deferred("emit_signal", "transition_complete")
