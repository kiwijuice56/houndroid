extends Label
class_name ScoreLabel

func _ready() -> void:
	GlobalData.world.connect("score_updated", self, "_on_score_updated")

func _on_score_updated(new_score: int) -> void:
	text = "%06d" % new_score
