extends PlayerState
class_name PlayerIdle

func physics_update(delta) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if get_input_direction() != Vector2():
		state_machine.transition_to("Run")
		return
	
	if Input.is_action_pressed("primary_weapon"):
		player.primary_weapon_shot()
	
	if abs(player.velocity.x) < player.move_speed * 0.35:
		player.velocity.x = 0
	else:
		player.velocity.x -= player.sprites.scale.x * player.move_speed * 0.35
	
	player.velocity.y += player.gravity * delta 
	
	if Input.is_action_pressed("jump") and not player.jumped:
		player.jump_step()
		player.velocity.y += player.jump_force

func enter(msg := {}) -> void:
	if player.is_shooting_primary:
		player.set_animations("idle", ["Body"])
	else:
		player.set_animations("idle")
