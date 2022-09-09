extends ArmadillotState
class_name ArmadillotCharge

export var string_length := 48.0
export var charge_time := 1.75
export var release_time := 0.3
export var ring_size := 8

var tip := Vector2() setget set_tip

func set_tip(new_tip: Vector2):
	tip = new_tip
	string.points[1] = new_tip
	ring.position = new_tip + new_tip.normalized() * ring_size

func enter(msg := {}) -> void:
	var dir := -(enemy.player.global_position - enemy.global_position).normalized()
	tween.interpolate_property(self, "tip", Vector2(), dir * string_length, charge_time,  Tween.TRANS_QUAD , Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property(self, "tip", null, Vector2(), release_time,  Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	state_machine.transition_to("Bounce", {"dir": -dir})

