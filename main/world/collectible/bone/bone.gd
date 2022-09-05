extends Collectible
class_name Bone

export var shine_time := 4.0
export var shine_random := 1.25

func _ready() -> void:
	$ShineTimer.connect("timeout", self, "_on_shine_timeout")
	$ShineTimer.start(shine_time + 2 * randf() * shine_random - shine_random)

func _on_shine_timeout() -> void:
	$SpriteAnimationPlayer.current_animation = "shine"

func collect() -> void:
	GlobalData.coin_count += 1
	GlobalData.score += 10
	$ShineTimer.stop()
	$CollisionShape2D.call_deferred("set_disabled", true)
	$SpriteAnimationPlayer.stop()
	$CoinSounds.play_sound()
	$JingleSounds.play_sound()
	$SpriteAnimationPlayer.current_animation = "collect"
	yield($SpriteAnimationPlayer, "animation_finished")
	call_deferred("emit_signal", "collect_finished")
