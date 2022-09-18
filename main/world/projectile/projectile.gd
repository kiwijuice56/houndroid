extends Area2D
class_name Projectile

export var lifespan := 2.0

# Most enemies tweak their delay to themselves to match animations
# This parameter is for the player to keep delays different for each weapon
# Same with the energy usage variable
export var delay := 2.5
export var energy_use := 1/16.0

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

func _physics_process(delta) -> void:
	physics_update(delta)

func physics_update(delta) -> void:
	pass
