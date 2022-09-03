extends CharacterState
class_name PlayerState

var player: Player

func _ready() -> void:
	player = state_owner as Player
	assert(player != null)

func get_input_direction() -> Vector2:
	return Vector2(
		-Input.get_action_strength("ui_left") +
		Input.get_action_strength("ui_right"), 0)
