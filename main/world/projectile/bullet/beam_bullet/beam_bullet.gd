extends Bullet
class_name BeamBullet

func _on_body_entered(body) -> void:
	$WallSounds.play_sound()
	destroy()

func _on_area_entered(area: Area2D) -> void:
	# Get owner of hitbox
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
