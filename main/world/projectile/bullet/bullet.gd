extends Projectile
class_name Bullet

export var damage := 1.0
export var speed := 0.0
export var persist := false
var direction := Vector2()

func _ready() -> void:
	scale.x = 1 if direction.x > 0 else -1

func _on_body_entered(body: Node2D) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	# Get owner of hitbox
	var parent = area.get_parent()
	if parent is Character:
		parent.hurt(damage)
	if not persist:
		call_deferred("queue_free")

func _physics_process(delta) -> void:
	global_position += delta * speed * direction
