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
	$VisibilityEnabler2D.connect("screen_entered", self, "_on_screen_entered")
	$VisibilityEnabler2D.connect("screen_exited", self, "_on_screen_exited")

# Used to disable/enable extra processing on child nodes

func _on_screen_entered() -> void:
	$StateMachine.set_physics_process(true)

func _on_screen_exited() -> void:
	# Prevent characters from zipping off-screen when they are disabled
	# velocity = Vector2()
	$StateMachine.set_physics_process(false)

# Godot built-in functions use multi-level calls, so we need to create a helper function to override the
# function for inheriting classes
func _physics_process(delta) -> void:
	physics_update(delta)

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

func physics_update(_delta) -> void:
	velocity = move_and_slide(velocity, Vector2.UP)
