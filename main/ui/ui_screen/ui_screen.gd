extends Control
class_name UIScreen

var ui_manager: UIScreenManager

signal transition_complete

func disable_input() -> void:
	pass

func enable_input() -> void:
	pass

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
