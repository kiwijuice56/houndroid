extends Area2D
class_name gravity_weakener

export var gravity_rate := 0.45
export var particle_per_scale := 0.125

func _ready():
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	
	var size: Vector2 = $CollisionShape2D.shape.extents
	
	$VisibilityEnabler2D.rect.position.x = -size.x
	$VisibilityEnabler2D.rect.position.y = -size.y
	
	$VisibilityEnabler2D.rect.size.x = size.x * 2
	$VisibilityEnabler2D.rect.size.y = size.y * 2
	
	$CPUParticles2D.amount = int(particle_per_scale) * size.x
	$CPUParticles2D2.amount = int(particle_per_scale) * size.x
	
	$CPUParticles2D.position.y = size.y 
	$CPUParticles2D2.position.y = size.y
	
	$CPUParticles2D.emission_rect_extents.x = size.x
	$CPUParticles2D2.emission_rect_extents.x = size.x
	

func _on_area_entered(area: Area2D) -> void:
	area.get_parent().gravity *= gravity_rate

func _on_area_exited(area: Area2D) -> void:
	area.get_parent().gravity /= gravity_rate
