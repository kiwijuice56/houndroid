extends UIScreen
class_name PlayerCustomizeScreen

export var menu_button_path: NodePath

export var weapon_button_path: NodePath
export var item_buttons: Array

var menu_button: Button

func _ready() -> void:
	menu_button = get_node(menu_button_path)
	menu_button.connect("pressed", self, "_on_menu_button_pressed")
	
	item_buttons.append_array(get_node(weapon_button_path).get_children())
	
	for button in item_buttons:
		button.initialize()
	
	disable_input()

func _on_menu_button_pressed() -> void:
	ui_manager.transition("PlayerCustomize", "LevelSelect")

func transition_to(to: String) -> void:
	match to:
		"LevelSelect":
			GlobalData.file_loader.save_file(0)
			
			Transition.trans_in()
			yield(Transition, "finished")
			visible = false
	call_deferred("emit_signal", "transition_complete")

func transition_from(from: String) -> void:
	match from:
		"LevelSelect":
			visible = true
			Transition.trans_out()
			yield(Transition, "finished")
	call_deferred("emit_signal", "transition_complete")
