extends TouchScreenButton
class_name Joystick

export var offset := Vector2()
export var inner_offset := Vector2()
export var radius := 32.0
export var true_radius := 84.0
export var inner_resistance := 0.5

func _ready() -> void:
	connect("released", self, "_on_release")

func _input(event) -> void:
	if not (event is InputEventScreenTouch or event is InputEventScreenDrag):
		return
	
	if is_pressed():
		var center := global_position + offset
		var distance: Vector2 = event.position - center
		if distance.length() > true_radius:
			return
		
		var direction: Vector2 = distance.normalized()
		
		if direction.x > 0:
			Input.action_release("ui_left")
			Input.action_press("ui_right", round(direction.x))
		else:
			Input.action_release("ui_right")
			Input.action_press("ui_left", round(abs(direction.x)))
		
		if direction.y < 0:
			Input.action_release("ui_down")
			Input.action_press("ui_up", round(abs(direction.y)))
		else:
			Input.action_release("ui_up")
			Input.action_press("ui_down", round(direction.y))
		
		if distance.length() > radius:
			distance = direction * radius
		
		$InnerJoystick.position = inner_offset + distance * inner_resistance

func _on_release() -> void:
	Input.action_release("ui_right")
	Input.action_release("ui_left")
	Input.action_release("ui_up")
	Input.action_release("ui_down")
	$InnerJoystick.position = inner_offset
