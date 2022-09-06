extends Area2D
class_name Animal

export(Array, Resource) var sprites := []
export var idle_time := 1.5
export var idle_time_rand := 0.5

var is_scared := false

func _ready() -> void:
	$Sprite.texture = sprites[randi() % len(sprites)]
	connect("area_entered", self, "_on_area_entered")
	$IdleTimer.connect("timeout", self, "_on_idle_timeout")
	$IdleTimer.start(idle_time + idle_time_rand * randf() * 2 - idle_time_rand)

func _on_area_entered(area: Area2D) -> void:
	scare()

func _on_idle_timeout() -> void:
	idle()
	$IdleTimer.start(idle_time + idle_time_rand * randf() * 2 - idle_time_rand)

func scare() -> void:
	$IdleTimer.stop()
	is_scared = true

func idle() -> void:
	pass
