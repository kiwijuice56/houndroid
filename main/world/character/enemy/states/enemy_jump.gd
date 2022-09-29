extends EnemyState
class_name EnemyJump

export var jump_time := 1.5
export var jump_rand := 0.3
export var timer_path: NodePath
export var jump_force := -300

var timer: Timer
var landed := false

func _ready() -> void:
	timer = get_node(timer_path)
	timer.connect("timeout", self, "_on_jump_timeout")

func _on_jump_timeout() -> void:
	enemy.set_animations("jump")
	yield(enemy.anim_players.get_node("Body"), "animation_finished")
	if state_machine.is_physics_processing():
		enemy.velocity.y += jump_force
	landed = false
	
	timer.start(jump_time + randf() * jump_rand * 2 - jump_rand)

func physics_update(delta) -> void:
	enemy.velocity.y += enemy.gravity * delta
	if enemy.is_on_floor() and not landed:
		landed = true
		enemy.set_animations("land")

func enter(_msg: Dictionary = {}) -> void:
	timer.start(jump_time + randf() * jump_rand * 2 - jump_rand)
