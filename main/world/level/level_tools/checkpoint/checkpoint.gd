extends Area2D
class_name Checkpoint

var entered := false

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area: Area2D) -> void:
	if not entered:
		enter_checkpoint(false)

func enter_checkpoint(already_collected: bool) -> void:
	GlobalData.checkpoint_index = get_index()
	GlobalData.store_level_properties()
	if not already_collected:
		$AnimationPlayer.current_animation = "enter"
		yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.current_animation = "[stop]"
	$Monitor.frame = 12
	$Light2D.color = Color("a6e4ff")
	entered = true
