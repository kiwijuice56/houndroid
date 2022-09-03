extends Label
class_name BoneCounter

func _ready() -> void:
	GlobalData.connect("coin_count_updated", self, "_on_coin_count_updated")

func _on_coin_count_updated(new_count: int) -> void:
	text = "x" + str(new_count)
