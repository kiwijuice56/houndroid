tool
extends EditorPlugin

var dock: SpritesheetAnimImportDock
var sprite: Sprite
var anim_player: AnimationPlayer

var selection := get_editor_interface().get_selection()
var is_docked := false

func _enter_tree() -> void:
	dock = preload("res://addons/gd-spritesheet-anim-import-main/ImportDock.tscn").instance()
	
	selection.connect("selection_changed", self,  "_on_selection_changed")
	dock.connect("animation_confirmed", self, "generate_animation")

func _exit_tree() -> void:
	if is_docked:
		remove_control_from_docks(dock)
	dock.free()

func _on_selection_changed() -> void:
	if is_docked:
		remove_control_from_docks(dock)
	is_docked = false
	
	var selected = selection.get_selected_nodes() 
	if selected == null or len(selected) != 2:
		return
	
	if not selected[0] is Sprite:
		return
	sprite = selected[0]
	
	if not selected[1] is AnimationPlayer:
		return
	anim_player = selected[1]
	
	is_docked = true
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)
	dock.initialize()

func generate_animation(anim_name: String, start: int, end: int, fps: int, duration: int, loop_mode: int) -> void:
	if anim_name == "":
		push_error("No animation name provided")
	
	if end == -1:
		end = sprite.hframes * sprite.vframes
	if start > end or end > sprite.hframes * sprite.vframes:
		push_error("Generated animation out of range of sprite frames")
		return
	
	var animation := Animation.new()
	if duration > 0:
		animation.length = ((end - start + 1) * duration) / 1000.0
	elif fps > 0:
		animation.length = (1.0 / fps) * (end - start + 1)
	else:
		push_error("No time information in animation generation. Initialize either the FPS or Frame Duration")
		return
	
	var track_index := animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, str(anim_player.get_parent().get_path_to(sprite)) + ":frame")
	
	for frame in range(start, end + 1):
		var time = animation.length * ((frame - start) / float(end - start + 1))
		animation.track_insert_key(track_index, time, frame)
	animation.track_insert_key(track_index, animation.length, end)
	
	animation.loop = loop_mode != 0
	
	anim_player.add_animation(anim_name, animation)
	print(loop_mode)
	update_overlays()
