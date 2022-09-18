extends AttractCollectible
class_name ScoreOrb

export(Array, Resource) var colors: Array

func _ready() -> void:
	$Sprite.texture = colors[randi() % len(colors)]

func collect() -> void:
	set_physics_process(false)
	$CollectSounds.play_sound()
	$AnimationPlayer.current_animation = "collect"
	yield($AnimationPlayer, "animation_finished")
	GlobalData.score += 20
	.collect()

