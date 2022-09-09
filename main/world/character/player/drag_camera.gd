extends Camera2D
class_name DragCamera

export var target_path: NodePath
# Amount that camera can offset x
export var max_drag := 4.0
# Speed that camera offset shifts
export var turn_speed := 0.08
# Bubble that player can move in before camera is updated
export var update_radius := 64

onready var target: KinematicBody2D = get_node(target_path)

var update_position := Vector2()
var dir_x := 0.0
var new_dir_x := 0.0

