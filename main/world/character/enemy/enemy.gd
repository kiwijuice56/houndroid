extends Character
class_name Enemy
# Extends character functionality to allow player detection and contact damage

export var health_orb: PackedScene
export var health_orb_chance := 0.2
export var score_orb: PackedScene
export var score_orb_count := 4

export var contact_damage := 1.0

var player: Player

signal body_entered_vision(body)
signal body_exited_vision(body)
signal enemy_died

func _ready() -> void:
	$Vision.connect("body_entered", self, "_on_body_entered_vision")
	$Vision.connect("body_exited", self, "_on_body_exited_vision")
	$Hitbox.connect("area_entered", self, "_on_area_entered")
	yield(GlobalData.world, "level_loaded")
	connect("enemy_died", GlobalData.world.player, "_on_enemy_died")

func _on_body_entered_vision(body: Node2D) -> void:
	player = body as Player
	emit_signal("body_entered_vision", body)

func _on_body_exited_vision(body: Node2D) -> void:
	emit_signal("body_exited_vision", body)
	if player == body:
		player = null

func _on_area_entered(area: Area2D) -> void:
	var player := area.get_parent() as Player
	if player == null:
		return
	player.hurt(contact_damage)

func hurt(damage: float) -> void:
	.hurt(damage)
	
	if health <= 0:
		death()
		return
	else:
		$Sounds/Hurt.play_sound()
		set_animations("hurt")

func death() -> void:
	emit_signal("enemy_died")
	for _i in range(score_orb_count):
		var new_orb := score_orb.instance()
		new_orb.dir = Vector2((randf() * 2 - 1 ) * 128, -128 * randf() - 128)
		GlobalInstanceManager.call_deferred("add_node", new_orb)
		new_orb.global_position = global_position
	
	if randf() < health_orb_chance:
		var new_orb := health_orb.instance()
		new_orb.dir = Vector2((randf() * 2 - 1 ) * 128, -128 * randf() - 128)
		GlobalInstanceManager.call_deferred("add_node", new_orb)
		new_orb.global_position = global_position
	
	$Sounds/Death.play_sound()
	set_animations("death")
	if has_node("Sprites/Shadow"):
		get_node("Sprites/Shadow").visible = false
	
	# Disable collision 
	$Hitbox.get_node("CollisionShape2D").call_deferred("set_disabled", true)
	get_node("CollisionShape2D").call_deferred("set_disabled", true)
	
	yield(anim_players.get_node("Hurt"), "animation_finished")
	
	queue_free()
