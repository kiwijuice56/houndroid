extends UIScreen
class_name LevelStartScreen
# Controls the screen that appears when starting the level

export var panel_path: NodePath
export var initial_offset_x := -400
export var transition_time := 0.8
export var wait_time := 1.5

var panel: Control

signal introduction_finished

func _ready() -> void:
	panel = get_node(panel_path)
	disable_input()

func transition_from(from: String) -> void:
	match from:
		# LevelSelect, GameOverlay
		_:
			$Tween.interpolate_property(panel, "rect_position:x", initial_offset_x, 0, transition_time)
			$Tween.start()
			
			visible = true
			
			yield($Tween, "tween_completed")
	call_deferred("emit_signal", "transition_complete")

func start_introduction() -> void:
	Transition.trans_out()
	yield(Transition, "finished")
	
	$Timer.start(wait_time)
	yield($Timer, "timeout")
	
	$Tween.interpolate_property(panel, "rect_position:x", null, initial_offset_x, transition_time)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	visible = false
	
	emit_signal("introduction_finished")
