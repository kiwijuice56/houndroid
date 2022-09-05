extends Node

# export variables that would allow for no absolute paths aren't usable in autoloads
var transition_scene := preload("res://main/ui/transition/TransitionLayer.tscn")

signal finished

var transition: CanvasLayer

func _ready() -> void:
	transition = transition_scene.instance()
	add_child(transition)

func trans_in() -> void:
	transition.get_node("AnimationPlayer").current_animation = "trans_in"
	yield(transition.get_node("AnimationPlayer"), "animation_finished")
	emit_signal("finished")

func trans_out() -> void:
	transition.get_node("AnimationPlayer").current_animation = "trans_out"
	yield(transition.get_node("AnimationPlayer"), "animation_finished")
	emit_signal("finished")
