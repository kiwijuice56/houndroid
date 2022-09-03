extends EnemyState
class_name EnemyStrafe

export var relocate_threshold := 32
export var relocate_range := 64

var origin := 0.0
var relocate_spot = 0.0

var move_direction := 0.0

func _ready() -> void:
	origin = enemy.global_position.x
	relocate_spot = origin

func physics_update(delta) -> void:
	enemy.velocity.y += enemy.gravity * delta
	if abs(enemy.global_position.x - relocate_spot) < relocate_threshold:
		var new_spot_dir := randf() * 2 - 1
		relocate_spot = origin + new_spot_dir * relocate_range
		move_direction = sign(relocate_spot - enemy.global_position.x)
	enemy.global_position.x += move_direction * enemy.move_speed * delta
