extends EnemyState
class_name EnemyHover
# Moves the enemy from random spots in the air within a set origin and radius

export var timer_path: NodePath
export var area_path: NodePath

# The distance from the destination that is considered complete
export var relocate_threshold := 32

# As fas as the enemy will consider relocating
export var relocate_range := 64

# The angle in radians that the enemy will deviate from a 1PI rotation
export var relocate_angle_threshold := 0.3

export var wait_time := 1.5

var origin := Vector2()
var relocate_spot := Vector2()
var move_direction := Vector2()

var can_move := true

var move_angle := 0.0
var initial_distance := 0.0

var timer: Node
var area: Node

func _ready() -> void:
	timer = get_node(timer_path)
	area = get_node(area_path)
	timer.connect("timeout", self, "_on_wait_timeout")
	area.connect("body_entered", self, "_on_body_entered")
	origin = enemy.global_position
	relocate_spot = origin

func physics_update(delta) -> void:
	move_direction = (relocate_spot - enemy.global_position).normalized()
	
	if (enemy.global_position - relocate_spot).length() < relocate_threshold:
		relocate()
	
	if can_move:
		enemy.velocity = enemy.move_speed * move_direction * 1.5 * (relocate_spot - enemy.global_position).length() / initial_distance
	else:
		enemy.velocity = Vector2()
	
	enemy.global_position += enemy.velocity * delta

func _on_body_entered(body: Node2D) -> void:
	relocate()

func relocate() -> void:
	move_angle += PI + relocate_angle_threshold * randf() * 2 - relocate_angle_threshold
	var new_spot_dir := Vector2(1, 0).rotated(move_angle)
	relocate_spot = origin + new_spot_dir * relocate_range
	initial_distance = (relocate_spot - enemy.global_position).length()
	
	can_move = false
	timer.start(wait_time)

func _on_wait_timeout() -> void:
	can_move = true
