extends TextureProgress
class_name HealthBar

var player: Player

func _ready() -> void:
	GlobalData.world.connect("level_loaded", self, "_on_level_loaded")

func _on_level_loaded() -> void:
	GlobalData.world.player.connect("health_changed", self, "_on_health_changed")
	value = 9

func _on_health_changed(health: float) -> void:
	value = int(health)
