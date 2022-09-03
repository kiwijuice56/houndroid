extends UIScreen
class_name TitleScreen

export var button_container_path: NodePath
var button_container: Container

func _ready() -> void:
	button_container = get_node(button_container_path)
	for button in button_container.get_children():
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
