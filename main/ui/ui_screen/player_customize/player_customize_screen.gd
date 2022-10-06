extends UIScreen
class_name PlayerCustomizeScreen

func _ready() -> void:
	disable_input()

func transition_to(to: String) -> void:
	match to:
		"LevelSelect":
			Transition.trans_in()
			yield(Transition, "finished")
			visible = false

func transition_from(from: String) -> void:
	match from:
		"LevelSelect":
			visible = true
			Transition.trans_out()
			yield(Transition, "finished")
