extends Character
class_name Player

export var primary_weapon_combo := 0.8
export var hurt_invincibility := 1.25

export var jump_force := -64.0
# Force applied to player when jump released
export var jump_cut := 80
export var run_jump_boost := 1.1
# Time allowed for jumping after falling
export var jump_fall := 0.05

export var friction := 12
export var slow_fall := 0.25

export var step_spark_probability := 0.6
export var fall_effect_distance := 8.0

export(Array, PackedScene) var bullet_scenes: Array
export var weapon_index := 0

export var death_effect_scene: PackedScene
export var death_effect_count: int
export var death_fall_delay := 0.5

var invulnerable := false
var can_shoot_primary := true
var is_shooting_primary := false

var jumped := false
var is_holding_jump := false
var can_jump := false

var last_shot_arm := "mr"

var weapon_energy := []

signal energy_changed(energy)

func _ready() -> void:
	$PrimaryForcedTimer.connect("timeout", self, "_on_primary_delay_finished")
	$PrimaryComboTimer.connect("timeout", self, "_on_primary_combo_finished")
	$HurtInvincibilityTimer.connect("timeout", self, "_on_hurt_invincibility_finished")
	$JumpFallTimer.connect("timeout", self, "_on_jump_fall_timeout")
	$Hitbox.connect("body_entered", self, "_on_body_entered")
	
	weapon_energy = []
	for _i in range(len(bullet_scenes)):
		weapon_energy.append(1.0)
	weapon_energy[0] = 0.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swap_weapon", false):
		swap_weapon()
	if event.is_action_released("jump"):
		jumped = false

func _on_primary_delay_finished() -> void:
	can_shoot_primary = true

func _on_primary_combo_finished() -> void:
	is_shooting_primary = false
	
	# Revert arm animations
	if $StateMachine.state == $StateMachine/Run:
		set_animations("run", ["ArmML", "ArmMR"])
	elif $StateMachine.state == $StateMachine/Idle:
		set_animations("idle", ["ArmML", "ArmMR"])
	elif $StateMachine.state == $StateMachine/Air:
		set_animations("jump", ["ArmML", "ArmMR"])

func _on_hurt_invincibility_finished() -> void:
	set_animations("hurt_complete")
	invulnerable = false

func _on_jump_fall_timeout() -> void:
	can_jump = false

func _on_body_entered(body: Node2D) -> void:
	if body is DamageTileMap:
		if body is DeathFallTileMap:
			$Hitbox/CollisionShape2D.call_deferred("set_disabled", true)
			var cam := $DragCamera
			remove_child(cam)
			GlobalInstanceManager.add_node(cam)
			cam.global_position = global_position
			$DeathFallTimer.start(death_fall_delay)
			yield($DeathFallTimer, "timeout")
		hurt(max_health, true)

func swap_weapon() -> void:
	weapon_index = (weapon_index + 1) % len(bullet_scenes)
	emit_signal("energy_changed", weapon_index, weapon_energy[weapon_index])

func primary_weapon_shot() -> void:
	if not $PrimaryForcedTimer.is_stopped():
		return
	
	is_shooting_primary = true
	can_shoot_primary = false
	
	var bullet: Projectile = bullet_scenes[weapon_index].instance()
	
	set_animations("shoot_wait", ["ArmML", "ArmMR"])
	$PrimaryForcedTimer.start(bullet.delay)
	$PrimaryComboTimer.start(primary_weapon_combo)
	
	if last_shot_arm == "mr":
		bullet.global_position = $Sprites/PrimaryGunEffectML/PrimaryShotSparksML.global_position
		set_animations("shoot", ["ArmML", "PrimaryGunEffectML"])
		last_shot_arm = "ml"
	else:
		bullet.global_position = $Sprites/PrimaryGunEffectMR/PrimaryShotSparksMR.global_position
		set_animations("shoot", ["ArmMR", "PrimaryGunEffectMR"])
		last_shot_arm = "mr"
	
	if bullet.energy_use > weapon_energy[weapon_index]:
		bullet.queue_free()
		return
	
	weapon_energy[weapon_index] -= bullet.energy_use 
	emit_signal("energy_changed", weapon_index, weapon_energy[weapon_index])
	
	$Sounds/PrimaryShot.play_sound()
	
	bullet.direction = Vector2($Sprites.scale.x, 0)
	bullet.speed += abs(velocity.x)
	GlobalInstanceManager.add_node(bullet)
	

# Called each time the player foot hits the floor in the animation
func run_step() -> void:
	if randf() < step_spark_probability:
		$WalkingSparks.emitting = true
		$WalkingSparks.direction.x = -$Sprites.scale.x
	$Sounds/Step.play_sound()

# Called when player lands after a fall
func fall_step(distance: float) -> void:
	$JumpFallTimer.stop()
	is_holding_jump = false
	can_jump = false
	if distance > fall_effect_distance:
		$FallingSparks.emitting = true
		$Sounds/Fall.play_sound()

# Called when player jumps
func jump_step() -> void:
	can_jump = false
	is_holding_jump = true
	jumped = true
	$Sounds/Jump.play_sound()

# Called when player walks into air
func slip_step() -> void:
	$JumpFallTimer.start(jump_fall)
	can_jump = true

func hurt(damage: float, prioirity := false) -> void:
	# Stop damage if invulernable unless priority (such as death pits)
	if invulnerable and not prioirity:
		return
	if has_node("DragCamera"):
		$DragCamera.add_trauma(.3)
	
	.hurt(damage)
	
	$HurtInvincibilityTimer.start(hurt_invincibility)
	invulnerable = true
	
	if health <= 0:
		death()
		return
	
	$Sounds/Hurt.play_sound()
	set_animations("hurt_initial")
	
	yield($AnimationPlayers/HurtInitial, "animation_finished")
	set_animations("hurt")

func death() -> void:
	GlobalData.ui_manager.get_screen("GameOverlay").disable_input()
	
	self.frozen = true
	$Hitbox/CollisionShape2D.call_deferred("set_disabled", true)
	var angle_change := (PI*2) / death_effect_count
	
	for i in range(death_effect_count):
		var new_effect := death_effect_scene.instance()
		GlobalInstanceManager.add_node(new_effect)
		new_effect.global_position = global_position
		new_effect.dir = Vector2(1, 0).rotated(angle_change * i)
	$Sounds/Death.play_sound()
	set_animations("death")
	yield($AnimationPlayers/Body, "animation_finished")
	
	LevelManager.reset_level()
