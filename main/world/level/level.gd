extends Node2D
class_name Level

onready var spawn: Position2D = $PlayerSpawn

func _ready() -> void:
	$DeathFallTile.visible = false
