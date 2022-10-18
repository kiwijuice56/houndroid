extends Light2D
class_name Shadow

export var shadow_owner_path: NodePath
export var max_distance := 80.0

onready var shadow_owner = get_node(shadow_owner_path)
onready var ray: RayCast2D = $RayCast2D

func _ready() -> void:
	texture_scale = 0
	position = Vector2()

func _process(_delta) -> void:
	ray.global_position = shadow_owner.global_position
	ray.force_raycast_update()
	if ray.is_colliding():
		var point: Vector2 = ray.get_collision_point()
		var distance: float = abs(point.y - shadow_owner.position.y)
		var new_scale := 1 - (distance / max_distance)
		if new_scale < 0:
			return
		texture_scale = new_scale
		global_position.y = point.y
	else:
		texture_scale = 0
		position = Vector2()
