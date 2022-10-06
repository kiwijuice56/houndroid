extends Node
class_name FileLoader
# Controls file saving and loading to keep user state

export var file_resource_path: String
export var save_file_path: String

func save_file(id: int) -> void:
	var new_file: Resource = load(file_resource_path).new()
	new_file.version = ProjectSettings.get("application/config/version")
	
	for node in get_tree().get_nodes_in_group("Save"):
		node.save_file(new_file.data)
	
	ResourceSaver.save(save_file_path + "save_file%03d.tres" % (id), new_file)

func load_file(id: int) -> void:
	var dir := Directory.new()
	dir.change_dir(save_file_path)
	dir.list_dir_begin()
	
	var file := dir.get_next()
	var save_file_resource: Resource
	
	while file != "":
		file = dir.get_next()
		if file.begins_with("save_file%03d.tres" % (id)):
			save_file_resource = ResourceLoader.load(save_file_path + file)
			break
	
	for node in get_tree().get_nodes_in_group("Save"):
		node.load_file(save_file_resource.data)
