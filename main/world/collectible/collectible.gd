extends Area2D
class_name Collectible

export var shine_time := 4.0
export var shine_random := 1.25
signal collect_finished

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area: Area2D) -> void:
	collect()
	yield(self, "collect_finished")
	call_deferred("queue_free")

func collect() -> void:
	call_deferred("emit_signal", "collect_finished")
