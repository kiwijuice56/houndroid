extends UIScreen
class_name LevelSelectScreen
# Controls the level select

export var level_info_scene: PackedScene
export(Array, Resource) var level_icons: Array

export var menu_button_path: NodePath
export var levels_path: NodePath

export var min_x := 0
export var max_x := 1024
export var de_accel := 128.0

var menu_button: Button
var levels: Control
var selected_info: LevelInfoContainer

var drag_velocity := Vector2()

func _ready() -> void:
	menu_button = get_node(menu_button_path)
	menu_button.connect("pressed", self, "_on_menu_button_pressed")
	
	# Go through each child and connect the level buttons scattered in the scene
	levels = get_node(levels_path)
	var stack := levels.get_children()
	while len(stack) > 0:
		var node: Node = stack.pop_back()
		if node is Button:
			node.connect("pressed", self, "_on_level_button_pressed", [node])
		stack += node.get_children()
	
	disable_input()

# Called when the back button is pressed 
func _on_menu_button_pressed() -> void:
	ui_manager.transition("LevelSelect", "Title")

# Called when any of the main button levels are pressed
func _on_level_button_pressed(button: Button) -> void:
	if is_instance_valid(selected_info):
		selected_info.queue_free()
	
	$Tween.interpolate_property(levels, "rect_position:x", null, (levels.rect_global_position.x) - button.get_global_rect().position.x + 225, 0.45, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	drag_velocity = Vector2()
	
	var new_info := level_info_scene.instance()
	levels.add_child(new_info)

	# Extraneous info that will have save data later on
	new_info.initialize(button, {"yay" : "info"}, level_icons[int(button.name)])
	new_info.connect("level_selected", self, "_on_level_selected")
	
	selected_info = new_info

# Called when the "go" button is pressed in a LevelSelect 
func _on_level_selected() -> void:
	var index := selected_info.index

	
	LevelManager.start_level(index)

func _input(event) -> void:
	if event is InputEventScreenDrag:
		drag_velocity = event.speed

# Updates the screen position from scrolling the screen or pressing on levels
func _process(delta) -> void:
	levels.rect_position.x += drag_velocity.x * delta
	if abs(drag_velocity.x) > de_accel * delta:
		drag_velocity.x += de_accel * -sign(drag_velocity.x) * delta
	else:
		drag_velocity.x = 0
	levels.rect_position.x = clamp(levels.rect_position.x, min_x, max_x)

func transition_to(to: String) -> void:
	if is_instance_valid(selected_info):
		selected_info.queue_free()
	
	match to:
		"Title":
			Transition.trans_in()
			yield(Transition, "finished")
			visible = false
		"LevelStart":
			Transition.trans_in()
			yield(Transition, "finished")
			visible = false
	call_deferred("emit_signal", "transition_complete")

func transition_from(from: String) -> void:
	match from:
		"Title":
			visible = true
			levels.rect_position.x = 0
			drag_velocity = Vector2()
			
			Transition.trans_out()
			yield(Transition, "finished")
		"LevelFinish":
			# copy for now, will have other function later
			visible = true
			levels.rect_position.x = 0
			drag_velocity = Vector2()
			
			Transition.trans_out()
			yield(Transition, "finished")
	call_deferred("emit_signal", "transition_complete")

func disable_input() -> void:
	.disable_input()
	if is_instance_valid(selected_info):
		selected_info.disable_input()
	menu_button.disabled = true
	set_process_input(false)
	set_process(false)

func enable_input() -> void:
	.enable_input()
	menu_button.disabled = false
	set_process_input(true)
	set_process(true)
