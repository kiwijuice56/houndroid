extends Collectible
class_name BoneCoin

export var shine_time := 4.0
export var shine_random := 1.25

var marked := false

func _ready() -> void:
	$ShineTimer.connect("timeout", self, "_on_shine_timeout")
	$ShineTimer.start(shine_time + 2 * randf() * shine_random - shine_random)

func _on_shine_timeout() -> void:
	$SpriteAnimationPlayer.current_animation = "shine"

func mark_collected() ->  void:
	marked = true
	modulate.a = 0.65

func collect() -> void:
	if not marked:
		GlobalData.world.add_to_level_state("new_coin_count", 1)
	GlobalData.world.add_to_level_state("total_coin_count", 1)
	GlobalData.world.add_to_level_state("score", 10)
	
	$ShineTimer.stop()
	$CollisionShape2D.call_deferred("set_disabled", true)
	$SpriteAnimationPlayer.stop()
	$CoinSounds.play_sound()
	$JingleSounds.play_sound()
	$SpriteAnimationPlayer.current_animation = "collect"
	yield($SpriteAnimationPlayer, "animation_finished")
	
	var p := str(get_path())
	GlobalData.world.get_level_state("recently_collected")[p.substr(p.find("Collectibles") + 13)] = true
	call_deferred("emit_signal", "collect_finished", get_path())
