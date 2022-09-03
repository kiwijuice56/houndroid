extends EnemyState
class_name EnemyFloat

func physics_update(delta) -> void:
	enemy.position.x += enemy.move_speed * delta
