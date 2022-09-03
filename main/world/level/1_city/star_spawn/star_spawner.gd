extends ParallaxLayer
class_name StarSpawner

export var star: PackedScene
export var star_count := 0
export var start := Vector2()
export var end := Vector2()

func _ready() -> void:
	for i in range(star_count):
		var new_star := star.instance()
		add_child(new_star)
		new_star.position.x = int(randf() * (end.x - start.x) + start.x)
		new_star.position.y = int(randf() * (end.y - start.y) + start.y)
