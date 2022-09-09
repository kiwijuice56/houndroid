extends Animal
class_name Bird

export var hop_length := 32.0
export var hop_height := -24.0
export var hop_time := 0.25
export var max_hops := 3
export var accel := Vector2(32, -256)

var speed := Vector2(64, -128)

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	speed += delta * accel
	global_position += speed * delta

func _on_screen_exited() -> void:
	._on_screen_exited()
	if is_scared:
		queue_free()

func scare() -> void:
	.scare()
	speed.x *= -scale.x
	$SpriteAnimationPlayer.current_animation = "scare"
	yield($SpriteAnimationPlayer, "animation_finished")
	$SpriteAnimationPlayer.current_animation = "fly"
	$VisibilityEnabler2D.physics_process_parent = true
	set_physics_process(true)

func idle() -> void:
	for _i in range(randi() % (max_hops - 1) + 1):
		if randf() < 0.5:
			scale.x *= -1
		
		$WallCast.force_raycast_update()
		$FloorCast.force_raycast_update()
		
		if $WallCast.is_colliding() or not $FloorCast.is_colliding():
			scale.x *= -1
		
		$Tween.interpolate_property(self, "position:x", null, position.x - hop_length * scale.x, hop_time)
		$Tween.interpolate_property(self, "position:y", null, position.y + hop_height, hop_time / 2)
		$Tween.start()
		yield($Tween, "tween_completed")
		$Tween.interpolate_property(self, "position:y", null, position.y - hop_height, hop_time / 2)
		$Tween.start()
		yield($Tween, "tween_all_completed")
