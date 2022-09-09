extends EnemyState
class_name EnemyFloat
# Simply moves the enemy to one side of the screen constantly

func physics_update(delta) -> void:
	enemy.position.x += enemy.move_speed * delta
