extends PanelContainer
class_name LevelInfoContainer

export var front_side_time := 1.5
export var back_side_time := 1.5
export var offset := Vector2()

signal level_selected

var index: int
var front_side := true


func _ready() -> void:
	$Button.connect("pressed", self, "emit_signal", ["level_selected"])
	$Timer.connect("timeout", self, "_on_timeout")

func _on_timeout() -> void:
	if front_side:
		$Tween.interpolate_property($VBoxContainer, "modulate:a", 1.0, 0.0, 0.1)
		$Tween.start()
		yield($Tween, "tween_completed")
		$Tween.interpolate_property($StatContainer, "modulate:a", 0.0, 1.0, 0.1)
		$Tween.start()
		yield($Tween, "tween_completed")
		
		$Timer.start(back_side_time)
	else:
		$Tween.interpolate_property($StatContainer, "modulate:a", 1.0, 0.0, 0.1)
		$Tween.start()
		yield($Tween, "tween_completed")
		$Tween.interpolate_property($VBoxContainer, "modulate:a", 0.0, 1.0, 0.1)
		$Tween.start()
		yield($Tween, "tween_completed")
		
		$Timer.start(back_side_time)
	front_side = !front_side

func initialize(button: Button, info: Dictionary, icon: Resource, color: Color) -> void:
	rect_global_position = button.rect_global_position
	rect_position += offset
	
	index = int(button.name)
	$VBoxContainer/TextureRect.texture = icon
	get("custom_styles/panel").set("bg_color", color)
	get("custom_styles/panel").set("border_color", color / 2)
	pop_up()

func pop_up() -> void:
	$Tween.interpolate_property(self, "rect_scale:y", 0.0, 1.0, 0.1)
	$Tween.start()
	yield($Tween, "tween_completed")
	$Tween.interpolate_property($VBoxContainer, "modulate:a", 0.0, 1.0, 0.1)
	$Tween.interpolate_property($Button, "modulate:a", 0.0, 1.0, 0.1)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Timer.start(front_side_time)

func queue_free() -> void:
	$Button.disabled = true
	$Timer.stop()
	$Tween.interpolate_property($StatContainer, "modulate:a", $StatContainer.modulate.a, 0.0, 0.1)
	$Tween.interpolate_property($VBoxContainer, "modulate:a", $VBoxContainer.modulate.a, 0.0, 0.1)
	$Tween.interpolate_property($Button, "modulate:a", 1.0, 0.0, 0.1)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property(self, "rect_scale:y", 1.0, 0.0, 0.1)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	.queue_free()

func disable_input() -> void:
	$Button.disabled = true
