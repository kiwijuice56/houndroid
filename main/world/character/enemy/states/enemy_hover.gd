extends EnemyState
class_name EnemyHover

export var ray_length := 16
export var relocate_threshold := 32
export var relocate_range := 64

var origin := Vector2()
var relocate_spot := Vector2()

var move_direction := Vector2()

func _ready() -> void:
	origin = enemy.global_position
	relocate_spot = origin

func physics_update(delta) -> void:
	move_direction = (relocate_spot - enemy.global_position).normalized()
	
	if enemy.is_on_ceiling() or enemy.is_on_floor() or enemy.is_on_wall() or (enemy.global_position - relocate_spot).length() < relocate_threshold:
		var new_spot_dir := Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
		relocate_spot = origin + new_spot_dir * relocate_range
	
	enemy.velocity = enemy.move_speed * move_direction
	
