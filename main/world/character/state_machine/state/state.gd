extends Node
class_name State

export var state_owner_path: NodePath

var state_machine: StateMachine
var state_owner: Node

func _ready() -> void:
	state_owner = get_node(state_owner_path)
	assert(state_owner != null)

func physics_update(_delta) -> void:
	pass

func exit() -> void:
	pass

func enter(_msg: Dictionary = {}) -> void:
	pass
