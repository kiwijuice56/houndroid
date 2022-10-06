extends UIScreen
class_name TitleScreen
# Controls the initial screen when starting the game

export var decoration_scene: PackedScene
export var button_container_path: NodePath
export var corner_button_container_path: NodePath

var button_container: Container
var corner_button_container: Container
var decoration: Node

func _ready() -> void:
	# The decoration is taxing on performance, so it must be deleted and spawned only when needed
	decoration = decoration_scene.instance()
	add_child(decoration)
	move_child(decoration, 0)
	button_container = get_node(button_container_path)
	corner_button_container = get_node(corner_button_container_path)
	
	for button in button_container.get_children() + corner_button_container.get_children():
		if not button is Button:
			continue
		button.connect("pressed", self, "_on_button_pressed", [button.name])
	
	enable_input()

func _input(event) -> void:
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		ui_manager.transition("Title", "LevelSelect")
		disable_input()

func _on_button_pressed(button_name: String) -> void:
	pass

func transition_to(to: String) -> void:
	match to:
		"LevelSelect":
			Transition.trans_in()
			yield(Transition, "finished")
			remove_child(decoration)
			decoration.queue_free()
			visible = false
		"GameOverlay":
			GlobalData.world.load_level()
			visible = false
	call_deferred("emit_signal", "transition_complete")

func transition_from(from: String) -> void:
	match from:
		"LevelSelect":
			visible = true
			decoration = decoration_scene.instance()
			add_child(decoration)
			move_child(decoration, 0)
			Transition.trans_out()
			yield(Transition, "finished")
	call_deferred("emit_signal", "transition_complete")

func disable_input() -> void:
	.disable_input()
	set_process_input(false)
	for button in button_container.get_children() + corner_button_container.get_children():
		if not button is Button:
			continue
		button.disabled = true

func enable_input() -> void:
	.enable_input()
	set_process_input(true)
	for button in button_container.get_children() + corner_button_container.get_children():
		if not button is Button:
			continue
		button.disabled = false
