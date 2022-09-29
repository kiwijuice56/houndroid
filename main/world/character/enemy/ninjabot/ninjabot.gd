extends Enemy
class_name Ninjabot

export var burst_size := 4
export var shuriken: PackedScene
export var shoot_delay := 1.25
export var attack_delay := 1.25

func _ready() -> void:
	$ShootDelayTimer.connect("timeout", self, "_on_shoot_delay_finished")
	$AttackDelayTimer.connect("timeout", self, "_on_attack_delay_finished")
	set_physics_process(false)

func _on_body_entered_vision(body: Node2D) -> void:
	._on_body_entered_vision(body)
	if player != null:
		$AttackDelayTimer.start(attack_delay / 2.0)

func _on_attack_delay_finished() -> void:
	for _i in range(burst_size):
		$ShootDelayTimer.start(shoot_delay)
		yield($ShootDelayTimer, "timeout")
	$AttackDelayTimer.start(attack_delay)

func _on_shoot_delay_finished() -> void:
	if health <= 0 or player == null:
		return
	var player_position := player.global_position
	
	#$Sounds/ChargeUp.play_sound()
	#set_animations("shoot")
	#yield(anim_players.get_node("Eye"), "animation_finished")
	
	# Must check again after waiting for animation
	if health <= 0:
		return
	
	var new_shuriken := shuriken.instance()
	GlobalInstanceManager.add_node(new_shuriken)
	if not is_on_floor():
		new_shuriken.direction = Vector2(sign(player_position.x - global_position.x), .5).normalized()
	else:
		new_shuriken.direction = Vector2(sign(player_position.x - global_position.x), 0)
	
	new_shuriken.global_position = global_position
	
	#$Sounds/LaserShot.play_sound()
	#$ShootSparks.emitting = true
	# set_animations("unwind")
	#$ShootDelayTimer.start(shoot_delay)
