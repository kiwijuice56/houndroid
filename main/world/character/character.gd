extends KinematicBody2D
class_name Character

export var move_speed := 0.0
export var gravity := 9.0

export var max_health := 1.0
var health := 1.0 setget set_health

onready var anim_players: Node = $AnimationPlayers
onready var sprites: Node2D = $Sprites

var game_world: GameWorld
var velocity := Vector2()

# Used to stop processing
var frozen := false setget set_frozen

signal health_changed(health)

func set_health(new_health) -> void:
	health = new_health
	emit_signal("health_changed", health)

func set_frozen(new_frozen: bool):
	frozen = new_frozen
	set_physics_process(not frozen)
	$StateMachine.set_physics_process(not frozen)

func _ready() -> void:
	self.health = max_health

func _physics_process(delta) -> void:
	velocity = move_and_slide(velocity, Vector2.UP)

func set_animations(anim_name: String, anim_player_names := []) -> void:
	if len(anim_player_names) == 0:
		for anim_player in anim_players.get_children():
			if not anim_player.current_animation == anim_name and anim_player.has_animation(anim_name):
				anim_player.current_animation = anim_name
	else:
		for anim_player_name in anim_player_names:
			var anim_player: AnimationPlayer = anim_players.get_node(anim_player_name)
			if not anim_player.current_animation == anim_name and anim_player.has_animation(anim_name):
				anim_player.current_animation = anim_name

func hurt(damage: int) -> void:
	self.health -= damage
	
