extends EnemyState
class_name EnemyWalk
# Moves the enemy back and forth on a flat surface, flipping at edges and walls

export var floor_ray_path: NodePath
export var wall_ray_path: NodePath

var floor_ray: RayCast2D
var wall_ray: RayCast2D
var direction := -1.0

func _ready() -> void:
	floor_ray = get_node(floor_ray_path)
	wall_ray = get_node(wall_ray_path)

func physics_update(delta) -> void:
	enemy.velocity.y += enemy.gravity * delta
	
	if enemy.is_on_floor():
		enemy.velocity.x = direction * enemy.move_speed
		if not floor_ray.is_colliding() or wall_ray.is_colliding():
			enemy.scale.x *= -1
			direction *= -1

func enter(msg := {}) -> void:
	enemy.set_animations("walk")
