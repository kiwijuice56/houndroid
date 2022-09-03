extends Bullet
class_name GravityBullet

export var gravity_speed := 60.0

var gravity_enabled := true
var velocity_y := 0.0

func _physics_process(delta) -> void:
	if gravity_enabled:
		velocity_y += gravity_speed * delta
		global_position.y += velocity_y
