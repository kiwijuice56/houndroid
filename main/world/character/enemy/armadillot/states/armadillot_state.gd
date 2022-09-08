extends EnemyState
class_name ArmadillotState

export var string_path: NodePath
export var ring_path: NodePath
export var tween_path: NodePath

var string: Node
var tween: Node
var ring: Node

func _ready() -> void:
	string = get_node(string_path)
	tween = get_node(tween_path)
	ring = get_node(ring_path)
