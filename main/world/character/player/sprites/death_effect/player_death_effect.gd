extends Sprite
class_name PlayerDeathEffect

export var de_accel := 3.0

var dir := Vector2()
var speed := 256

func _physics_process(delta) -> void:
	speed -= de_accel * delta
	position += dir * speed * delta
