extends EnemyState
class_name EnemyBounce

export var wall_particle_path: NodePath

export var max_collisions := 6
export var transition: String
export var decay := 0.1
export var decay_extra := 0.05

onready var wall_particles: Node = get_node(wall_particle_path)
var collisions := 0

func physics_update(delta) -> void:
	var collision = enemy.move_and_collide(enemy.velocity * delta)
	if collision:
		collisions += 1
		enemy.sounds.get_node("Bump").play_sound()
		enemy.velocity = enemy.velocity.bounce(collision.normal) * (1.0 - (decay + decay_extra * collisions))
		
		if collisions >= max_collisions:
			state_machine.transition_to(transition)
			return
		wall_particles.direction = collision.normal
		wall_particles.emitting = true
		wall_particles.global_position = enemy.global_position - 20 * collision.normal

func enter(msg := {}) -> void:
	collisions = 0
	enemy.set_animations("spin")
	enemy.velocity = msg.dir * enemy.move_speed 
