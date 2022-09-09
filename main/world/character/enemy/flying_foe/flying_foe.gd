extends Enemy
class_name FloatingFoe

export var orb: PackedScene
export var shoot_delay := 1.25

func _ready() -> void:
	$ShootDelayTimer.connect("timeout", self, "_on_shoot_delay_finished")
	set_physics_process(false)

func _on_body_entered_vision(body: Node2D) -> void:
	._on_body_entered_vision(body)
	if player != null:
		$ShootDelayTimer.start(shoot_delay)

func _on_shoot_delay_finished() -> void:
	if health <= 0 or player == null:
		return
	var player_position := player.global_position
	
	$Sounds/ChargeUp.play_sound()
	set_animations("shoot")
	yield(anim_players.get_node("Eye"), "animation_finished")
	
	# Must check again after waiting for animation
	if health <= 0:
		return
	
	var new_orb := orb.instance()
	GlobalInstanceManager.add_node(new_orb)
	new_orb.direction = (player_position- global_position).normalized()
	new_orb.global_position = $ShootSparks.global_position
	
	$Sounds/LaserShot.play_sound()
	$ShootSparks.emitting = true
	set_animations("unwind")
	$ShootDelayTimer.start(shoot_delay)
