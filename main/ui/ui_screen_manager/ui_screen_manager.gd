extends Control
class_name UIScreenManager
# Provides access to all UI overlays in a centralized class to allow for transitions between overlays

signal transition_complete

func _ready() -> void:
	for child in get_children():
		# Get past the CanvasLayer parent that all UIScreens have
		if not child is CanvasLayer:
			return
		child.get_child(0).ui_manager = self

func get_screen(screen: String) -> Node:
	return get_node(screen + "Layer").get_child(0)

func transition(from: String, to: String) -> void:
	var from_node = get_node(from + "Layer").get_child(0)
	var to_node = get_node(to + "Layer").get_child(0)
	
	from_node.disable_input()
	
	from_node.transition_to(to)
	yield(from_node, "transition_complete")
	to_node.transition_from(from)
	yield(to_node, "transition_complete")
	
	to_node.enable_input()
	
	emit_signal("transition_complete")
