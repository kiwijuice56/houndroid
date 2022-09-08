extends Enemy
class_name Armadillot

# Min and max times between each flash
export var flash_time := 1.5
export var flash_time_min := 0.3

# Length of a flash
export var flash_length := 0.1
export var flash_cutoff := 0.8

export var anim_speed_min := 0.5

func physics_update(delta) -> void:
	pass

func _ready() -> void:
	$NormalFlashEndTimer.connect("timeout", self, "_on_flash_end")
	$NormalFlashTimer.connect("timeout", self, "_on_flash_start")

func _on_flash_start() -> void:
	$NormalFlashEndTimer.start(flash_length)
	$Sprites.get_node("Top").visible = true
	$Sprites.get_node("BlurTop").visible = false

func _on_flash_end() -> void:
	var progress :=  (velocity.length()) / (move_speed)
	
	if progress > flash_cutoff:
		$Sprites.get_node("Top").visible = false
		$Sprites.get_node("BlurTop").visible = true
	else:
		$Sprites.get_node("Top").visible = true
		$Sprites.get_node("BlurTop").visible = false
	
	$AnimationPlayers/BlurTop.playback_speed = progress * (1.0 - anim_speed_min) + anim_speed_min
	$AnimationPlayers/Top.playback_speed = progress * (1.0 - anim_speed_min) + anim_speed_min
	print($AnimationPlayers/BlurTop.playback_speed)
	$NormalFlashTimer.start(progress * (flash_time - flash_time_min) + flash_time_min)

func set_animations(anim_name: String, anim_player_names := []) -> void:
	.set_animations(anim_name, anim_player_names)
	if anim_name == "spin":
		$NormalFlashTimer.start(flash_time)
		$Sprites.get_node("Top").visible = false
		$Sprites.get_node("BlurTop").visible = true
		$Trail.emitting = true
	else:
		$AnimationPlayers/BlurTop.playback_speed = 1.0
		$AnimationPlayers/Top.playback_speed = 1.0
		$NormalFlashEndTimer.stop()
		$NormalFlashTimer.stop()
		$Trail.emitting = false
