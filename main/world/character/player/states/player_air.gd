extends PlayerState
class_name PlayerAir

var origin := Vector2()

func physics_update(delta) -> void:
	var input := get_input_direction()
	
	if Input.is_action_just_pressed("jump"):
		if player.can_jump:
			player.jump_step()
			player.velocity.y = player.jump_force
		else:
			player.is_jump_queued = true
	
	if player.is_on_floor():
		player.fall_step(abs((player.global_position - origin).y))
		state_machine.transition_to("Idle")
		return
	
	if player.is_holding_jump and player.velocity.y < -player.jump_cut:
		if Input.is_action_just_released("jump"):
			player.velocity.y += player.jump_cut
			player.is_holding_jump = false
	
	if Input.is_action_pressed("primary_weapon"):
		player.primary_weapon_shot()
	
	if input.x != 0:
		player.sprites.scale.x = 1 if input.x > 0 else -1
	player.velocity.x = input.x * player.move_speed
	player.velocity.y += player.gravity * delta
	
	var animation := "jump"
	if player.anim_players.get_node("Body").current_animation != "land":
		if player.is_shooting_primary:
			player.set_animations(animation, ["Body"])
		else:
			player.set_animations(animation)

func enter(msg := {}) -> void:
	origin = player.global_position
