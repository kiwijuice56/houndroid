extends AttractCollectible
class_name HealthOrb

func _on_body_entered(body: Node2D) -> void:
	player = body

func collect() -> void:
	set_physics_process(false)
	$CollectSounds.play_sound()
	$AnimationPlayer.current_animation = "collect"
	yield($AnimationPlayer, "animation_finished")
	GlobalData.world.player.health += 1
	.collect()

