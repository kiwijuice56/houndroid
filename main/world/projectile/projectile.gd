extends Area2D
class_name Projectile

export var lifespan := 2.0

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	connect("body_entered", self, "_on_body_entered")
	$DecayTimer.connect("timeout", self, "_on_decay_timeout")
	$DecayTimer.start(lifespan)

func _on_area_entered(_area: Area2D) -> void:
	pass

func _on_body_entered(_body: Node2D) -> void:
	pass

func _on_decay_timeout() -> void:
	queue_free()
