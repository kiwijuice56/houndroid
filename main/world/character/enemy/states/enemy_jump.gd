extends EnemyState
class_name EnemyJump

export var jump_time := 1.5
export var jump_rand := 0.3
export var timer_path: NodePath
export var jump_force := -300

var timer: Timer

func _ready() -> void:
	timer = get_node(timer_path)
	timer.connect("timeout", self, "_on_jump_timeout")

func _on_jump_timeout() -> void:
	if state_machine.is_physics_processing():
		enemy.velocity.y += jump_force
	
	timer.start(jump_time + randf() * jump_rand * 2 - jump_rand)

func physics_update(delta) -> void:
	enemy.velocity.y += enemy.gravity * delta

func enter(_msg: Dictionary = {}) -> void:
	timer.start(jump_time + randf() * jump_rand * 2 - jump_rand)
