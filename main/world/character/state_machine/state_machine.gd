extends Node
class_name StateMachine

export var label_path: NodePath
export var initial_state: NodePath

# Ultimately decides whether physics_process of this state machine is ever enabled
export var uses_physics_process := true

onready var label := get_node(label_path)

var state: Node

signal transitioned(state_name)

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
	state.physics_update(delta)

func set_physics_process(enabled: bool) -> void:
	.set_physics_process(uses_physics_process and enabled and not owner.frozen)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	assert(has_node(target_state_name))
	if state != null:
		state.exit()
	call_deferred("set", "state", get_node(target_state_name))
	get_node(target_state_name).call_deferred("enter", msg)
	emit_signal("transitioned", state.name)
	label.text = state.name
