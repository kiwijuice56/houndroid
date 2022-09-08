extends KinematicBody2D
class_name MovingPlatform

export var fast_cycle := false

export var speed := 5.0
var point_index := 0

var attached := []
var dir := Vector2()
var relocate_dist: float

func _ready() -> void:
	relocate_dist = speed
	
	var anchor_direction: Vector2 = ($Points/B.global_position - $Points/A.global_position).normalized()
	
	$Anchors/Anchor1.global_position = $Points/A.global_position + anchor_direction * relocate_dist
	$Anchors/Anchor2.global_position = $Points/B.global_position - anchor_direction * relocate_dist
	
	global_position = $Points.get_child(0).global_position
	
	# Use a smaller screen notifier to make the platform move faster when far away from the player
	if fast_cycle:
		_on_screen_exited()
		$NearScreenNotifier.connect("screen_entered", self, "_on_screen_entered")
		$NearScreenNotifier.connect("screen_exited", self, "_on_screen_exited")

func _physics_process(delta) -> void:
	if (global_position - $Points.get_child(point_index).global_position).length() < relocate_dist:
		point_index = (point_index + 1) % $Points.get_child_count()
		dir = ($Points.get_child(point_index).global_position - global_position).normalized()
		
	global_position += dir * speed * delta

func _on_screen_entered() -> void:
	speed /= 16

func _on_screen_exited() -> void:
	speed *= 16
