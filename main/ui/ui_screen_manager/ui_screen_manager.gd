extends Control
class_name UIScreenManager
# Provides access to all UI overlays in a centralized
# class to allow for transitions between overlays

func _ready() -> void:
	for child in get_children():
		if not child is CanvasLayer:
			return
		# Get past first child - the CanvasLayer
		child.get_child(0).ui_manager = self

func transition(from: String, to: String) -> void:
	var from_node = get_node(from + "Layer").get_child(0)
	var to_node = get_node(to + "Layer").get_child(0)
	
	from_node.disable_input()
	
	
	from_node.transition_to(to)
	yield(from_node, "transition_complete")
	to_node.transition_from(from)
	yield(to_node, "transition_complete")
	
	to_node.enable_input()
