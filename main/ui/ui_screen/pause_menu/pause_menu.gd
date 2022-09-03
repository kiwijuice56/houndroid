extends UIScreen
class_name GameMenu

export var menu_button_path: NodePath
export var music_slider_path: NodePath
export var sound_effect_slider_path: NodePath

var menu_button: Button
var music_slider: Slider
var sound_effect_slider: Slider

func _ready() -> void:
	menu_button = get_node(menu_button_path)
	music_slider = get_node(music_slider_path)
	sound_effect_slider = get_node(sound_effect_slider_path)
	
	menu_button.connect("pressed", self, "_on_menu_button_pressed")
	music_slider.connect("changed", self, "_on_music_slider_changed")
	sound_effect_slider.connect("changed", self, "_on_sound_effect_slider_changed")

func _on_music_slider_changed() -> void:
	GlobalData.music_volume = music_slider.value

func _on_sound_effect_slider_changed() -> void:
	GlobalData.sound_effect_volume = sound_effect_slider.value

func _on_menu_button_pressed() -> void:
	ui_manager.transition("PauseMenu", "GameOverlay")

func transition_to(to: String) -> void:
	match to:
		"GameOverlay":
			menu_button.visible = false
			visible = false
	call_deferred("emit_signal", "transition_complete")

func transition_from(from: String) -> void:
	match from:
		"GameOverlay":
			menu_button.visible = true
			visible = true
	call_deferred("emit_signal", "transition_complete")
