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
	player.velocity.x = 0
	player.velocity.y += player.gravity * delta 
	
	if Input.is_action_just_pressed("jump") or player.is_jump_queued:
		player.jump_step()
		player.velocity.y += player.jump_force

func enter(msg := {}) -> void:
	player.set_animations("idle")
