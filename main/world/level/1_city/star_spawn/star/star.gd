extends Sprite
class_name Star

export(Array, Color) var colors: Array
export(Array, Resource) var textures: Array

func _ready() -> void:
	texture = textures[randi() % len(textures)]
	modulate = colors[randi() % len(colors)]
	$VisibilityNotifier2D.connect("screen_entered", self, "screen_entered")

func screen_entered() -> void:
	visible = true
	$Timer.start(randf())
	yield($Timer, "timeout")
	$AnimationPlayer.current_animation = "twinkle"

func screen_exited() -> void:
	visible = false
	$AnimationPlayer.current_animation = "[stop]"
