extends Control
class_name UIScreen

signal input_changed

var ui_manager: UIScreenManager

signal transition_complete

var input_disabled := false

func disable_input() -> void:
	input_disabled = true
	emit_signal("input_changed", self, input_disabled)

func enable_input() -> void:
	input_disabled = false
	emit_signal("input_changed", self, input_disabled)

func transition_from(from: String) -> void:
	match from:
		_:
			pass
	call_deferred("emit_signal", "transition_complete")

func transition_to(to: String) -> void:
	match to:
		_:
			pass
	call_deferred("emit_signal", "transition_complete")
