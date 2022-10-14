extends UIScreen
class_name GameOverlayScreen
# Controls gameplay overlay and handles interface between World and the UI

export var world_path: NodePath
export var menu_button_path: NodePath
export var button_control_path: NodePath
export var joystick_control_path: NodePath
export var weapon_button_path: NodePath

export var fade_transition_time = 0.4

var menu_button: Button
var world: GameWorld
var button_control: Control
var joystick_control: Control
var weapon_button: TouchScreenButton

func _ready() -> void:
	world = get_node(world_path)
	menu_button = get_node(menu_button_path)
	menu_button.connect("pressed", self, "_on_menu_button_pressed")
	button_control = get_node(button_control_path)
	joystick_control = get_node(joystick_control_path)
	weapon_button = get_node(weapon_button_path)
	weapon_button.connect("pressed", self, "_on_weapon_button_pressed")
	
	# ui_manager variable is not initialized yet, which would cause a null pointer exception
	yield(get_parent().get_parent(), "ready")
	ui_manager.get_screen("PauseMenu").connect("jump_shoot_swapped", self, "_on_jump_shoot_swapped")
	
	disable_input()

func _on_menu_button_pressed() -> void:
	ui_manager.transition("GameOverlay", "PauseMenu")

func _on_jump_shoot_swapped(swapped: bool) -> void:
	if not swapped:
		button_control.get_node("JumpButton").position = button_control.get_node("JumpNormal").position
		button_control.get_node("ShootButton").position = button_control.get_node("ShootNormal").position
	else:
		button_control.get_node("JumpButton").position = button_control.get_node("JumpSwap").position
		button_control.get_node("ShootButton").position = button_control.get_node("ShootSwap").position

func _on_weapon_button_pressed() -> void:
	GlobalData.world.player.swap_weapon()

func transition_to(to: String) -> void:
	match to:
		"PauseMenu":
			get_tree().paused = true
			menu_button.modulate.a = 0.0
		"LevelStart":
			modulate.a = 0.0
		"LevelFinish":
			GlobalData.world.lock_player()
			modulate.a = 1.0
			$Tween.stop_all()
			$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, fade_transition_time)
			$Tween.start()
	call_deferred("emit_signal", "transition_complete")

func transition_from(from: String) -> void:
	match from:
		"PauseMenu":
			get_tree().paused = false
			menu_button.modulate.a = 1.0
		"TitleScreen":
			visible = true
		"LevelStart":
			
			menu_button.modulate.a = 1.0
			visible = true
			modulate.a = 0.0
			$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, fade_transition_time)
			$Tween.start()
			GlobalData.world.unlock_player()
	call_deferred("emit_signal", "transition_complete")

func enable_input() -> void:
	.enable_input()
	menu_button.disabled = false
	joystick_control.get_node("Joystick").set_process_input(true)

func disable_input() -> void:
	.disable_input()
	menu_button.disabled = true
	joystick_control.get_node("Joystick").set_process_input(false)
