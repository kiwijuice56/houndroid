extends Node2D
class_name Level

onready var spawn: Position2D = $PlayerSpawn
onready var goal: Area2D = $Goal
onready var checkpoints: Node2D = $Checkpoints

func _ready() -> void:
	$DeathFallTile.visible = false
