extends EnemyState
class_name EnemyIdle
# Keeps the enemy stable while attempting to transition idle once the player is spotted

export var idle_time := 0.9
export var idle_rand := 0.15
export var transition: String

export var timer_path: NodePath

var timer: Node

func _ready() -> void:
	enemy.connect("body_exited_vision", self, "_on_body_exited_vision")
	enemy.connect("body_entered_vision", self, "_on_body_entered_vision")
	timer = get_node(timer_path)
	timer.connect("timeout", self, "_on_idle_timeout")

func _on_body_exited_vision(body: Node2D) -> void:
	timer.stop()

func _on_body_entered_vision(body: Node2D) -> void:
	if state_machine.state == self:
		timer.start(idle_time + idle_rand * randf() * 2 - idle_rand)

func _on_idle_timeout() -> void:
	state_machine.transition_to(transition)

func enter(msg := {}) -> void:
	if enemy.player != null:
		timer.start(idle_time + idle_rand * randf() * 2 - idle_rand)
	enemy.set_animations("idle")
