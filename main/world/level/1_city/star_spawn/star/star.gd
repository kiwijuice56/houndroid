extends Sprite
class_name Star

export(Array, Color) var colors: Array
export(Array, Resource) var textures: Array
export var anim_rand := 0.4

func _ready() -> void:
	texture = textures[randi() % len(textures)]
	modulate = colors[randi() % len(colors)]
	if randf() > anim_rand:
		screen_entered()
		$VisibilityNotifier2D.connect("screen_entered", self, "screen_entered")

func screen_entered() -> void:
	visible = true
	$Timer.start(randf())
	yield($Timer, "timeout")
	$AnimationPlayer.current_animation = "twinkle"

func screen_exited() -> void:
	visible = false
	$AnimationPlayer.current_animation = "[stop]"
