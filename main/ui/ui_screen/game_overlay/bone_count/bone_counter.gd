extends Label
class_name BoneCounter

func _ready() -> void:
	GlobalData.world.connect("coin_count_updated", self, "_on_coin_count_updated")

func _on_coin_count_updated(new_count: int) -> void:
	text = "%d" % new_count
