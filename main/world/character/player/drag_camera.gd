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
var dir := Vector2(1, 0)

func _physics_process(_delta) -> void:
	var new_dir := Vector2(sign(target.velocity.x), -1.0)
	
	if new_dir.x == 0:
		return
	
	if abs(target.global_position.x - update_position.x) > update_radius:
		dir.x += new_dir.x * turn_speed
	dir.x = max(-1.0, min(dir.x, 1.0))
	
	if dir.x == new_dir.x:
		update_position = target.global_position
	
	offset.x = dir.x * max_drag
