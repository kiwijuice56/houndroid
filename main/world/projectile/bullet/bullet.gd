extends Projectile
class_name Bullet

export var damage := 1.0
export var speed := 0.0
export var pierce := 1
export var persist := false
export var add_shooter_speed := true

var direction := Vector2()
var hits: int = 0

func _ready() -> void:
	scale.x = 1 if direction.x > 0 else -1

func _on_body_entered(body: Node2D) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	# Get owner of hitbox
	var parent = area.get_parent()
	if parent is Character:
		parent.hurt(damage)
		hits = hits + 1
	if not persist and hits >= pierce:
		call_deferred("queue_free")

func physics_update(delta) -> void:
	global_position += delta * speed * direction
