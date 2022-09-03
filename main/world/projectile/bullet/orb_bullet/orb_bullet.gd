extends Bullet
class_name OrbBullet

var player: Player
var is_stuck := false
var stuck_offset := Vector2()

func _on_area_entered(area: Area2D) -> void:
	# Get owner of hitbox
	var parent = area.get_parent()
	if parent is Player:
		$CollisionShape2D.call_deferred("set_disabled", true)
		player = parent
		is_stuck = true
		parent.hurt(damage)
		stuck_offset = player.global_position - global_position
		$AnimationPlayer.current_animation = "destroy"
		yield($AnimationPlayer, "animation_finished")
		call_deferred("queue_free")

func _physics_process(delta) -> void:
	if is_stuck:
		global_position = player.global_position - stuck_offset
