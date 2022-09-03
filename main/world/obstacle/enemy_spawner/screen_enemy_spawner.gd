extends Area2D
class_name ScreenEnemySpawner

export var spawn: PackedScene
export var spawn_delay := 1.25
export var offset_x := 500
var player: Player

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	$SpawnDelay.connect("timeout", self, "_on_delay_timeout")

func _on_area_entered(area: Area2D) -> void:
	player = area.get_parent()
	$SpawnDelay.start(spawn_delay)

func _on_area_exited(area: Area2D) -> void:
	$SpawnDelay.stop()

func _on_delay_timeout() -> void:
	if player == null:
		return
	var enemy := spawn.instance()
	GlobalInstanceManager.add_node(enemy)
	enemy.global_position.x = player.global_position.x + offset_x
	
	var extent_y: float = $CollisionShape2D.shape.extents.y
	enemy.global_position.y = global_position.y + (randf() * extent_y * 2) - extent_y
	$SpawnDelay.start(spawn_delay)
