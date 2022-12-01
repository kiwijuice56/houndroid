extends Bullet
class_name TrackBullet

export var turn_speed := 3
var tracked: Enemy

func _ready() -> void:
	$TrackRange.connect("area_entered", self, "_on_range_entered")
	$TrackRange.connect("area_exited", self, "_on_range_exited")
	$ExplodeRange/CollisionShape2D.disabled = true
	$ExplodeRange.connect("area_entered", self, "_on_enemy_exploded")
	if scale.x == -1:
		rotation_degrees = 180
	scale.x = 1

func _on_range_entered(area: Area2D) -> void:
	tracked = area.get_parent()

func _on_range_exited(area: Area2D) -> void:
	if tracked == area.get_parent():
		tracked = null

func _on_enemy_exploded(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Character:
		parent.hurt(1)

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
	$ExplodeRange/CollisionShape2D.call_deferred("set", "disabled", false)
	$GunTrail.emitting = false
	$AnimationPlayer.current_animation = "destroy_track"
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func _physics_process(delta) -> void:
	if is_instance_valid(tracked):
		rotation_degrees = rad2deg(Vector2(1, 0).angle_to(direction))
		var enemy_dir := (tracked.global_position - global_position).normalized()
		direction = lerp(direction, enemy_dir, delta * turn_speed)
