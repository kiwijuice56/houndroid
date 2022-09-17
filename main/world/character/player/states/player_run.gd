extends PlayerState
class_name PlayerRun

var displace_origin: Vector2

func physics_update(delta) -> void:
	if not player.is_on_floor():
		player.slip_step()
		state_machine.transition_to("Air")
		return
	
	var input := get_input_direction()
	
	if input == Vector2():
		state_machine.transition_to("Idle")
		return
	
	if Input.is_action_pressed("primary_weapon"):
		player.primary_weapon_shot()
	
	player.sprites.scale.x = 1 if input.x > 0 else -1
	player.velocity.x = input.x * player.move_speed
	
	player.velocity.y += player.gravity * delta 
	
	if Input.is_action_just_pressed("jump") or player.is_jump_queued:
		player.jump_step()
		player.velocity.y += player.jump_force

func enter(msg := {}) -> void:
	if player.is_shooting_primary:
		player.set_animations("run", ["Body"])
	else:
		player.set_animations("run")
