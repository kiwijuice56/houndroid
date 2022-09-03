extends State
class_name CharacterState

var game_character: Character

func _ready() -> void:
	game_character = state_owner as Character
	assert(game_character != null)
