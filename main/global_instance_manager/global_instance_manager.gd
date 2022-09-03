extends Node
# Handles all spawned objects (projectiles, enemies, etc.) to delete them during scene reloads

var nodes: Array = []

func _ready() -> void:
	get_parent().call_deferred("move_child", self, get_parent().get_child_count())

func add_node(node: Node) -> void:
	get_tree().get_root().add_child(node)
	nodes.append(node)

func clear_nodes() -> void:
	for node in nodes:
		if not is_instance_valid(node):
			continue
		node.queue_free()
	nodes.clear()
