extends TextureProgress
class_name WeaponBar

export var icon_path: NodePath
export var flash_path: NodePath
export(Array, Resource) var weapon_icons: Array
export(Array, Color) var modulates: Array

onready var icon: TextureRect = get_node(icon_path)
onready var flash: AnimationPlayer = get_node(flash_path)
var player: Player
var last_index := 0

func _ready() -> void:
	GlobalData.world.connect("level_loaded", self, "_on_level_loaded")

func _on_level_loaded() -> void:
	GlobalData.world.player.connect("energy_changed", self, "_on_energy_changed")
	# Initialize for player start
	_on_energy_changed(0, 0)

func _on_energy_changed(weapon_index: int, energy: float) -> void:
	icon.texture = weapon_icons[weapon_index]
	icon.modulate = modulates[weapon_index]
	modulate = modulates[weapon_index]
	value = round(energy * 16)
	if weapon_index != last_index:
		flash.current_animation = "flash"
	last_index = weapon_index
