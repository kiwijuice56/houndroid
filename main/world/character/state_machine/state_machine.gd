extends Node
class_name StateMachine

signal transitioned(state_name)

export var initial_state: NodePath
var state

func _ready() -> void:
	yield(owner, "ready")
	if has_node(initial_state):
		state = get_node(initial_state)
	for child in get_children():
		var state_child = child
		assert(state_child != null)
		state_child.state_machine = self
	if state != null:
		state.enter()

func _physics_process(delta) -> void:
	if state != null:
		state.physics_update(delta)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	assert(has_node(target_state_name))
	if state != null:
		state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
