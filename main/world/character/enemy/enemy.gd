extends Character
class_name Enemy

export var contact_damage := 1.0
var player: Player

func _ready() -> void:
	$Vision.connect("body_entered", self, "_on_body_entered_vision")
	$Vision.connect("body_exited", self, "_on_body_exited_vision")
	$Hitbox.connect("area_entered", self, "_on_area_entered")

func _on_body_entered_vision(body: Node2D) -> void:
	player = body as Player

func _on_body_exited_vision(body: Node2D) -> void:
	if player == body:
		player = null

func _on_area_entered(area: Area2D) -> void:
	var player := area.get_parent() as Player
	if player == null:
		return
	player.hurt(contact_damage)

func hurt(damage: int) -> void:
	.hurt(damage)
	
	if health <= 0:
		$Sounds/Death.play_sound()
		set_animations("death")
		
		# Disable collision 
		$Hitbox.get_node("CollisionShape2D").call_deferred("set_disabled", true)
		get_node("CollisionShape2D").call_deferred("set_disabled", true)
		
		yield($AnimationPlayers/Hurt, "animation_finished")
		queue_free()
	else:
		$Sounds/Hurt.play_sound()
		set_animations("hurt")
