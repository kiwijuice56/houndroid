extends UIScreen
class_name GameOverlay
# Controls gameplay overlay and handles interface between
# World and the UI

export var world_path: NodePath
export var menu_button_path: NodePath

var menu_button: Button
var world: GameWorld

func _ready() -> void:
	world = get_node(world_path)
	menu_button = get_node(menu_button_path)
	menu_button.connect("pressed", self, "_on_menu_button_pressed")

func _on_menu_button_pressed() -> void:
	ui_manager.transition("GameOverlay", "PauseMenu")

func transition_to(to: String) -> void:
	match to:
		"PauseMenu":
			get_tree().paused = true
			menu_button.modulate.a = 0.0
	call_deferred("emit_signal", "transition_complete")

func transition_from(from: String) -> void:
	match from:
		"PauseMenu":
			get_tree().paused = false
			menu_button.modulate.a = 1.0
		"TitleScreen":
			visible = true
	call_deferred("emit_signal", "transition_complete")
