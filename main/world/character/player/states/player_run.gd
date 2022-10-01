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
	
	if player.velocity.x != 0:
		player.sprites.scale.x = sign(player.velocity.x)
	
	player.velocity.x += input.x * player.move_speed * player.friction * delta
	player.velocity.x = clamp(player.velocity.x, -player.move_speed, player.move_speed)
	
	player.velocity.y += player.gravity * delta 
	
	if Input.is_action_pressed("jump") and not player.jumped:
		player.jump_step()
		player.velocity.y += player.jump_force * player.run_jump_boost
		state_machine.transition_to("Air")

func enter(msg := {}) -> void:
	if player.is_shooting_primary:
		player.set_animations("run", ["Body"])
	else:
		player.set_animations("run")
