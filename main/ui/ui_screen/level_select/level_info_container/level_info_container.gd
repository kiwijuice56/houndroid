extends PanelContainer
class_name LevelInfoContainer

export var coin_label_path: NodePath
export var time_label_path: NodePath

var coin_label: Label
var time_label: Label

export var front_side_time := 1.5
export var back_side_time := 1.5
export var offset := Vector2()

signal level_selected

var index: int
var front_side := true

func _ready() -> void:
	coin_label = get_node(coin_label_path)
	time_label = get_node(time_label_path)
	
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

func initialize(button: Button, info, level_name: String, icon: Resource, color: Color) -> void:
	rect_global_position = button.rect_global_position
	rect_position += offset
	
	index = int(button.name)
	$VBoxContainer/TextureRect.texture = icon
	get("custom_styles/panel").set("bg_color", color)
	get("custom_styles/panel").set("border_color", color / 2)
	
	$VBoxContainer/TitleLabel.text = level_name
	
	if info != null:
		coin_label.text = str(info["total_coin_count"])
		
		var secs = info["time"]
		var mins = secs / 60
		if mins > 9:
			time_label.text = "9:59"
		else:
			secs = secs % 60
			time_label.text = "%01d:%02d" % [mins, secs]
	
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
