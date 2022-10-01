extends KinematicBody2D
class_name Character
# Base class for all players and enemies

# Generally, the speed that characters directly control within states, such
# as the player walking speed or enemy flying speed
export var move_speed := 0.0

export var gravity := 9.0
export var max_health := 1.0

# Ultimately decides whether physics_process of this character is ever enabled
export var uses_physics_process := true

# Stored references for other classes to access
onready var anim_players: Node = $AnimationPlayers
onready var sprites: Node2D = $Sprites
onready var sounds: Node2D = $Sounds

var health := 1.0 setget set_health
var velocity := Vector2()

# Used to stop processing
var frozen := false setget set_frozen

signal health_changed(health)

func set_health(new_health) -> void:
	health = new_health
	health = clamp(health, 0, max_health)
	emit_signal("health_changed", health)

func set_frozen(new_frozen: bool):
	frozen = new_frozen
	set_physics_process(not frozen)
	$StateMachine.set_physics_process(not frozen)

func _ready() -> void:
	self.health = max_health
	$VisibilityEnabler2D.connect("screen_entered", self, "_on_screen_entered")
	$VisibilityEnabler2D.connect("screen_exited", self, "_on_screen_exited")
	
	if not $VisibilityEnabler2D.is_on_screen():
		_on_screen_exited()

# Link VisibilityEnabler to StateMachine processing as well
func _on_screen_entered() -> void:
	# Play any animations that characters have when entering the screen
	set_animations("screen_entered")
	$StateMachine.set_physics_process(true)
	set_physics_process(true)

func _on_screen_exited() -> void:
	$StateMachine.set_physics_process(false)
	set_physics_process(false)

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

func set_physics_process(enabled: bool) -> void:
	.set_physics_process(uses_physics_process and enabled and not frozen)

func hurt(damage: float) -> void:
	self.health -= damage

func physics_update(_delta) -> void:
	velocity = move_and_slide(velocity, Vector2.UP)
