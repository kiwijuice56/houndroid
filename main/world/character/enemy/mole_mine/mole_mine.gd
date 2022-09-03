extends Enemy
class_name MoleMine

func _on_area_entered(area: Area2D) -> void:
	._on_area_entered(area)
	health = 0
	hurt(0)
