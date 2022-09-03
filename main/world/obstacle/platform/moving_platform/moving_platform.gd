extends KinematicBody2D
class_name MovingPlatform

export var speed := 5.0
var point_index := 0

var attached := []
var dir := Vector2()

func _ready() -> void:
	global_position = $Points.get_child(0).global_position


func _physics_process(delta) -> void:
	if (global_position - $Points.get_child(point_index).global_position).length() < speed :
		point_index = (point_index + 1) % $Points.get_child_count()
		dir = ($Points.get_child(point_index).global_position - global_position).normalized()
		
	global_position += dir * speed * delta

