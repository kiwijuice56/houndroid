extends Light2D

export var shadow_owner_path: NodePath
export var max_distance := 80.0

onready var shadow_owner = get_node(shadow_owner_path)

func _process(_delta) -> void:
	$RayCast2D.global_position = shadow_owner.global_position
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		var point: Vector2 = $RayCast2D.get_collision_point()
		var distance: float = abs(point.y - shadow_owner.position.y)
		var new_scale := 1 - (distance / max_distance)
		if new_scale < 0:
			return
		texture_scale = new_scale
		global_position.y = point.y
	else:
		texture_scale = 0
		position = Vector2()
