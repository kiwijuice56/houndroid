extends UIScreen
class_name LevelStartScreen
# Controls the screen that appears when starting the level

export var label_path: NodePath
export var panel_path: NodePath
export var light_path1: NodePath
export var light_path2: NodePath

export var initial_offset_x := -400
export var transition_time := 0.8
export var wait_time := 1.5

export var speed := 1

export(Array, String) var random_lines := []

var label: Label
var panel: PanelContainer
var light1: Sprite

signal introduction_finished

func _ready() -> void:
	label = get_node(label_path)
	panel = get_node(panel_path)
	light1 = get_node(light_path1)
	panel.self_modulate.a = 0
	light1.self_modulate.a = 0
	disable_input()

func transition_from(from: String) -> void:
	speed = 1
	match from:
		# LevelSelect, GameOverlay
		_:
			$TitleDecoration.visible = true
			$Mask.visible = true
			enable_input()
			light1.self_modulate.a = 1
			$Light.visible = true
			
			$Tween.interpolate_property(panel, "self_modulate:a", 0.0, 1.0, 0.5)
			$Tween.start()
			
			label.self_modulate.a = 1.0
			label.text = ""
			label.visible_characters = 0
			$AudioStreamPlayer.playing = true
			
			random_lines.shuffle()
			
			visible = true
			yield(add_word("> LOADING LEVEL ..."), "completed")
			$Timer.start(0.06)
			yield($Timer, "timeout")
			yield(add_word(" COMPLETE!\n"), "completed")
			
			yield(add_word("> LOADING HOUNDROID ...\n"), "completed")
			
			yield(add_word(random_lines[0].substr(0, random_lines[0].find_last(".") + 1)), "completed")
			$Timer.start(0.06)
			yield($Timer, "timeout")
			yield(add_word(random_lines[0].substr(random_lines[0].find_last(".") + 1) + "\n"), "completed")
			
			yield(add_word(random_lines[1].substr(0, random_lines[1].find_last(".") + 1)), "completed")
			$Timer.start(0.06)
			yield($Timer, "timeout")
			yield(add_word(random_lines[1].substr(random_lines[1].find_last(".") + 1) + "\n"), "completed")
			
			yield(add_word(random_lines[2].substr(0, random_lines[2].find_last(".") + 1)), "completed")
			$Timer.start(0.06)
			yield($Timer, "timeout")
			yield(add_word(random_lines[2].substr(random_lines[2].find_last(".") + 1) + "\n"), "completed")
			
			
			yield(add_word("\n\nGO FOR IT!!!"), "completed")
			$Timer.start(0.5)
			yield($Timer, "timeout")
			
			$AudioStreamPlayer.playing = false
			
			$Tween.interpolate_property(light1, "self_modulate:a", 1.0, 0.0, 0.55)
			$Tween.interpolate_property(panel, "self_modulate:a", 1.0, 0.0, 0.55)
			$Tween.interpolate_property(label, "self_modulate:a", 1.0, 0.0, 1.0)
			$Tween.start()
			yield($Tween, "tween_all_completed")
			$TitleDecoration.visible = false
			$Mask.visible = false
			disable_input()
	call_deferred("emit_signal", "transition_complete")

func start_introduction() -> void:
	Transition.trans_out()
	yield(Transition, "finished")
	
	$Timer.start(wait_time)
	yield($Timer, "timeout")
	
	visible = false
	
	emit_signal("introduction_finished")

func add_word(word: String) -> void:
	$Tween.interpolate_property($AudioStreamPlayer, "volume_db", null, 0, 0.1 * speed)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	label.text += word
	$Tween.interpolate_property(label, "visible_characters", null, label.get_total_character_count(), len(word) * 0.01 * speed)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	$Tween.interpolate_property($AudioStreamPlayer, "volume_db", null, -60, 0.1 * speed)
	$Tween.start()
	yield($Tween, "tween_completed")

func _input(event) -> void:
	speed = 0.35 if Input.is_action_pressed("primary_weapon") else 1.0

