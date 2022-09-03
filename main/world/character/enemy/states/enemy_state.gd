extends CharacterState
class_name EnemyState

var enemy: Enemy

func _ready() -> void:
	enemy = state_owner as Enemy
	assert(enemy != null)
