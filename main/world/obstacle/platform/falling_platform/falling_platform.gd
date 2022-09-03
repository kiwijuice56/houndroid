extends KinematicBody2D
class_name FallingPlatform

export var fall_time := 2.0
export var accel := 128
var speed := 0.0


func _ready() -> void:
	set_physics_process(false)
	$FallArea.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node2D) -> void:
	if body.velocity.y < 0:
		return
	$AnimationPlayer.current_animation = "rumble"
	$FallTimer.start(fall_time)
	yield($FallTimer, "timeout")
	set_physics_process(true)
	$AnimationPlayer.current_animation = "[stop]"

func _physics_process(delta) -> void:
	speed += accel * delta
	position.y += speed * delta
