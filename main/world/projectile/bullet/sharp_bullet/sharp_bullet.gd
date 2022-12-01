extends Bullet
class_name SharpBullet

export var spread := 0.7

func _ready() -> void:
	var rot_rad: float = randf() * spread * 2 - spread
	rotate(rot_rad)
	direction = direction.rotated(rot_rad)
	$GunTrail.rotation_degrees = rotation_degrees
	$GunTrail.angle = -rotation_degrees

func _on_body_entered(body) -> void:
	$WallSounds.play_sound()
	destroy()

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Character:
		parent.hurt(damage)
		hits = hits + 1
	if not persist and hits >= pierce:
		destroy()

func _on_decay_timeout() -> void:
	destroy()

func destroy() -> void:
	set_physics_process(false)
	$GunTrail.emitting = false
	$AnimationPlayer.current_animation = "destroy"
	yield($AnimationPlayer, "animation_finished")
	queue_free()
