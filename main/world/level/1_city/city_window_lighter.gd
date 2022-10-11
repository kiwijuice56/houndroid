extends TileMap
class_name CityWindowLighter

export(Array, int) var off_tiles := []
export(Array, int) var on_tiles := []
export(Array, Resource) var shadows := []
export(Array, Color) var colors := []
export var window_cover: Resource
export var window_alpha_m := .25
export var unshaded_material: Resource

export var shadow_chance := 0.35
export var window_light_time := 1.5
export var window_light_rand := 0.5
export var light_range := 512.0
export var light_off_range := 512.0
export var max_attempts := 8

var turned_on := []
var instanced_shadows := []
var instanced_covers := []

func _ready():
	$Timer.connect("timeout", self, "_on_light_timeout")
	$Timer.start(window_light_time + 2 * window_light_rand * randf() - window_light_rand)

func _on_light_timeout() -> void:
	if not is_instance_valid(GlobalData.world.player):
		return
	var pos: Vector2 = GlobalData.world.player.global_position 
	
	# While loop required because range() is cached
	var i := 0
	while i < len(turned_on):
		var tile: Vector2 = turned_on[i]
		if ((tile * 32) - pos).length() > light_off_range:
			set_cellv(tile, off_tiles[on_tiles.find(get_cellv(tile))])
			turned_on.remove(i)
			if instanced_shadows[i] != null:
				instanced_shadows[i].queue_free()
			instanced_shadows.remove(i)
			instanced_covers[i].queue_free()
			instanced_covers.remove(i)
			i -= 1
		i += 1
	
	var light_pos: Vector2
	var attempts := 0
	
	while (not get_cellv(light_pos / 32.0) in off_tiles) and attempts <= max_attempts:
		attempts += 1
		light_pos = Vector2(pos.x - light_range + light_range * 2 * randf(), pos.y - light_range + light_range * 2 * randf()) 
	
	if attempts < max_attempts:
		set_cellv(light_pos / 32, on_tiles[off_tiles.find(get_cellv(light_pos / 32))])
		
		turned_on.append(light_pos / 32)
		
		var cover_sprite := Sprite.new()
		cover_sprite.texture = window_cover
		cover_sprite.modulate = colors[randi() % len(colors)]
		cover_sprite.modulate.a *= window_alpha_m
		cover_sprite.material = unshaded_material
		add_child(cover_sprite)
		
		cover_sprite.global_position = Vector2(int(light_pos.x / 32) * 32, int(light_pos.y / 32) * 32) + Vector2(16, 16)
		instanced_covers.append(cover_sprite)
		
		if randf() < shadow_chance:
			var sprite := Sprite.new()
			sprite.texture = shadows[randi() % len(shadows)]
			sprite.centered = false
			add_child(sprite)
			sprite.global_position = Vector2(int(light_pos.x / 32) * 32, int(light_pos.y / 32) * 32)
			instanced_shadows.append(sprite)
		else:
			instanced_shadows.append(null)
	
	$Timer.start(window_light_time + 2 * window_light_rand * randf() - window_light_rand)
