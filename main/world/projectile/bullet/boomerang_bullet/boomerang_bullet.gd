extends Bullet
class_name BoomerangBullet

export var initial_angle_rand := 0.3
export var angle_change := 0.02
export var de_accel := 2.0

var move_angle := -1.2 + (2 * initial_angle_rand * randf() - initial_angle_rand)
var boom_direction := Vector2(1, 0)

func _on_area_entered(area: Area2D) -> void:
	# Get owner of hitbox
	var parent = area.get_parent()
	if parent is Character:
		parent.hurt(damage)
		hits = hits + 1
	if not persist and hits >= pierce:
		destroy()
	$HitEffect.emitting = true

func _on_decay_timeout() -> void:
	$AnimationPlayer.current_animation = "fade"
	yield($AnimationPlayer, "animation_finished")
	destroy()

func destroy() -> void:
	set_physics_process(false)
	queue_free()

func physics_update(delta) -> void:
	speed -= delta * de_accel
	
	move_angle += angle_change * delta
	
	boom_direction = Vector2(1, 0).rotated(move_angle)
	global_position += Vector2(speed * direction.x, speed) * boom_direction * delta 
