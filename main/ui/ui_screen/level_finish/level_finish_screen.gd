extends UIScreen
class_name LevelFinishScreen

export var panel_path: NodePath
export var initial_offset_x := 0
export var final_offset_x := 300
export var transition_time := 0.8
export var wait_time := 1.5

var panel: Control

func _ready() -> void:
	panel = get_node(panel_path)
	disable_input()

func transition_from(from: String) -> void:
	match from:
		"GameOverlay":
			visible = true
			
			$AnimationPlayer.current_animation = "transition_in"
			yield($AnimationPlayer, "animation_finished")
			
			$Timer.start(wait_time)
			yield($Timer, "timeout")
			$Tween.interpolate_property(panel, "rect_position:x", final_offset_x, initial_offset_x, transition_time)
			$Tween.start()
			yield($Tween, "tween_completed")
			Transition.trans_in()
			yield(Transition, "finished")
			GlobalData.world.unload_level()
			visible = false
			
	call_deferred("emit_signal", "transition_complete")
