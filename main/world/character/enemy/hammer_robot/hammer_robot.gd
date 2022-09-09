extends Enemy
class_name HammerRobot
# Extends the enemy class to shoot saws 

export var hammer: PackedScene

export var shoot_delay := 1.5
export var shoot_random := 0.35
export var shoot_up_tolerance := 64

export(Array, float) var up_throw_angle_cycle: Array

var angle_index := 0

func _ready() -> void:
	$ShootDelayTimer.connect("timeout", self, "_on_shoot_delay_finished")
	set_animations("walk1")
	$StepDelayTimer.start()
	yield($StepDelayTimer, "timeout")
	set_animations("walk2")

func _on_body_entered_vision(body: Node2D) -> void:
	._on_body_entered_vision(body)
	if player != null:
		$ShootDelayTimer.start(shoot_delay + randf() * 2 * shoot_random - shoot_random)

func _on_body_exited_vision(body: Node2D) -> void:
	$ShootDelayTimer.stop()

func _on_shoot_delay_finished() -> void:
	if health <= 0 or player == null:
		return
	var player_position := player.global_position
	var x_dir = -1 if (player_position - global_position).x < 0 else 1
	var y_dist = (player_position - global_position).y
	
	$Sprites.scale.x = -x_dir
	
	set_animations("charge_up")
	yield($AnimationPlayers/Body, "animation_finished")
	
	if abs(y_dist) > shoot_up_tolerance:
		set_animations("charge_right")
	else:
		set_animations("charge_left")
	set_animations("charge_saw")
	$Sprites/Saw/SawSparks.emitting = true
	yield($AnimationPlayers/Antenna, "animation_finished")
	
	if health <= 0:
		return
	
	var new_hammer := hammer.instance()
	GlobalInstanceManager.add_node(new_hammer)
	
	if abs(y_dist) > shoot_up_tolerance:
		new_hammer.direction = Vector2(x_dir, -1) * Vector2(1, 0).rotated(deg2rad(up_throw_angle_cycle[angle_index]))
		angle_index = (angle_index + 1) % len(up_throw_angle_cycle)
		
		set_animations("unwind_right")
	else:
		new_hammer.direction = Vector2(x_dir, 0)
		new_hammer.gravity_enabled = false
		
		set_animations("unwind_left")
	new_hammer.global_position = global_position
	$Sprites/Saw/SawSparks.emitting = false
	set_animations("rise")
	yield($AnimationPlayers/Antenna, "animation_finished")
	
	set_animations("unwind")
	$ShootDelayTimer.start(shoot_delay + randf() * 2 * shoot_random - shoot_random)

func run_step() -> void:
	$StepSounds.play_sound()
