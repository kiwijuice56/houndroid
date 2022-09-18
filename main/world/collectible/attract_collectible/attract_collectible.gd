extends Collectible
class_name AttractCollectible

export var settle_speed := Vector2(8, 16)
export var gravity_speed := 32
export var deaccel_x := 64
export var attract_accel := Vector2(32, 32)

var dir := Vector2()
var player: Player

func _ready() -> void:
	$AttractionArea.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node2D) -> void:
	player = body

func _physics_process(delta) -> void:
	if not player:
		if abs(dir.x) > settle_speed.x:
			dir.x += -sign(dir.x) * deaccel_x *delta
		if dir.y < settle_speed.y:
			dir.y += gravity_speed *  delta
	else:
		var distance := player.global_position - global_position
		dir += attract_accel * distance.normalized()
	
	global_position += dir * delta

