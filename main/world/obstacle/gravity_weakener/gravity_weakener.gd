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
	

func _on_area_entered(area: Area2D) -> void:
	$AreaSounds.play_sound()
	$EnterSounds.play_sound()
	
	$ParticleLayer/FrontParticles.emitting = true
	$ParticleLayer/BackParticles.emitting = true
	
	$TransferParticles.emitting = true
	$TransferParticles.global_position = area.global_position
	area.get_parent().gravity *= gravity_rate

func _on_area_exited(area: Area2D) -> void:
	$AreaSounds.wipe_sounds()
	$LeaveSounds.play_sound()
	
	$ParticleLayer/FrontParticles.emitting = false
	$ParticleLayer/BackParticles.emitting = false
	
	$TransferParticles.emitting = true
	$TransferParticles.global_position = area.global_position
	area.get_parent().gravity /= gravity_rate
