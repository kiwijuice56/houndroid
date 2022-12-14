extends UIScreen
class_name GameMenu
# Controls the pause menu and updates the settings associated with it

export var menu_button_path: NodePath
export var music_slider_path: NodePath
export var sound_effect_slider_path: NodePath
export var button_switch_path: NodePath
export var button_switch_label_path: NodePath
export var quit_button_path: NodePath

var menu_button: Button
var quit_button: Button
var music_slider: Slider
var sound_effect_slider: Slider
var button_switch: CheckButton
var button_switch_label: Label

signal jump_shoot_swapped(swapped)

func _ready() -> void:
	menu_button = get_node(menu_button_path)
	quit_button = get_node(quit_button_path)
	music_slider = get_node(music_slider_path)
	sound_effect_slider = get_node(sound_effect_slider_path)
	button_switch = get_node(button_switch_path)
	button_switch_label = get_node(button_switch_label_path)
	
	menu_button.connect("pressed", self, "_on_menu_button_pressed")
	quit_button.connect("pressed", self, "_on_quit_button_pressed")
	music_slider.connect("value_changed", self, "_on_music_slider_changed")
	sound_effect_slider.connect("value_changed", self, "_on_sound_effect_slider_changed")
	button_switch.connect("toggled", self, "_on_button_switch_toggle")
	
	button_switch_label.visible = OS.has_touchscreen_ui_hint()
	button_switch.visible = OS.has_touchscreen_ui_hint()
	
	disable_input()

func _on_music_slider_changed(new_value: float) -> void:
	GlobalData.music_volume = new_value

func _on_sound_effect_slider_changed(new_value: float) -> void:
	GlobalData.sound_effect_volume = new_value

func _on_menu_button_pressed() -> void:
	ui_manager.transition("PauseMenu", "GameOverlay")

func _on_quit_button_pressed() -> void:
	LevelManager.quit_level()

func _on_button_switch_toggle(button_pressed: bool) -> void:
	emit_signal("jump_shoot_swapped", not button_pressed)

func transition_to(to: String) -> void:
	match to:
		"GameOverlay":
			menu_button.visible = false
			visible = false
		"LevelSelect":
			Transition.trans_in()
			yield(Transition, "finished")
			# A bit of a hack, but we need to make the screen invisible again for the transition 
			GlobalData.ui_manager.get_screen("GameOverlay").modulate.a = 0
			menu_button.visible = false
			visible = false
	call_deferred("emit_signal", "transition_complete")

func transition_from(from: String) -> void:
	match from:
		"GameOverlay":
			menu_button.visible = true
			visible = true
	call_deferred("emit_signal", "transition_complete")

func disable_input() -> void:
	.disable_input()
	menu_button.disabled = true
	music_slider.editable = false
	quit_button.disabled = true
	sound_effect_slider.editable = false
	button_switch.disabled = true

func enable_input() -> void:
	.enable_input()
	menu_button.disabled = false
	quit_button.disabled = false
	music_slider.editable = true
	sound_effect_slider.editable = true
	button_switch.disabled = false
