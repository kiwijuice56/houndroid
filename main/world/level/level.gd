extends Node2D
class_name Level

onready var spawn: Position2D = $PlayerSpawn
onready var goal: Area2D = $Goal

func _ready() -> void:
	$DeathFallTile.visible = false
