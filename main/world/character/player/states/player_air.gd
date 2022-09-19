extends PlayerState
class_name PlayerAir

var max_height := 0

func physics_update(delta) -> void:
	var input := get_input_direction()
	
	if player.is_holding_jump and player.velocity.y < -player.jump_cut:
		if Input.is_action_just_released("jump"):
			player.velocity.y += player.jump_cut
			player.is_holding_jump = false
	
	if Input.is_action_pressed("primary_weapon"):
		player.primary_weapon_shot()
	
	if player.velocity.x != 0:
		player.sprites.scale.x = sign(player.velocity.x)
	if input.x != 0:
		player.velocity.x += input.x * player.move_speed * 0.35
	else:
		if abs(player.velocity.x) < player.move_speed * 0.35:
			player.velocity.x = 0
		else:
			player.velocity.x -= player.sprites.scale.x * player.move_speed * 0.35
	player.velocity.x = clamp(player.velocity.x, -player.move_speed, player.move_speed)
	
	if not player.can_jump:
		player.velocity.y += player.gravity * delta
	else:
		player.velocity.y = 0
	
	if Input.is_action_just_pressed("jump") and player.can_jump:
		player.jump_step()
		player.velocity.y += player.jump_force
	
	if player.is_on_floor():
		player.fall_step(abs(max_height - player.global_position.y))
		state_machine.transition_to("Idle")
		return
	
	max_height = min(max_height, player.global_position.y)

func enter(msg := {}) -> void:
	max_height = 1000000
	if player.is_shooting_primary:
		player.set_animations("jump", ["Body"])
	else:
		player.set_animations("jump")
