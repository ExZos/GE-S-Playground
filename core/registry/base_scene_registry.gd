extends Resource

class_name BaseSceneRegistry

@export var preloads: Array[StringName]

var _paths: Dictionary[StringName, String] = {}
var _lookup: Dictionary[StringName, PackedScene] = {}
var is_init: bool = false

func init() -> void:
	if is_init:
		return
	
	# Retrieve all scene paths
	var scan_path: String = get_scan_path()
	var dir = DirAccess.open(scan_path)
	
	if not dir:
		push_error("???: Cannot open directory: ", scan_path)
		return
	
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	
	while not file_name.is_empty():
		if dir.current_is_dir():
			_scan_dir(scan_path + "/" + file_name)
		
		file_name = dir.get_next()
	
	# Preload lookup data
	for string_name in preloads:
		_lookup[string_name] = load(_paths.get(string_name))
	
	is_init = true

func get_scan_path() -> String:
	assert(false, "BaseSceneRegistry: Subclass must override get_scan_path()")
	return ""

func _scan_dir(dir_path: String) -> void:
	var dir = DirAccess.open(dir_path)
	
	if not dir:
		push_error("BaseSceneRegistry: Cannot open directory '%s'" % dir_path)
		return
	
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	
	while not file_name.is_empty():
		if file_name.ends_with(".tscn"):
			_paths[file_name.get_basename()] = dir_path + "/" + file_name
		
		file_name = dir.get_next()

func get_scene(type: StringName) -> PackedScene:
	if not _lookup.has(type):
		push_error("BaseSceneRegistry: Scene type '%s' was requested but never preloaded" % type)
		return null
	
	return _lookup.get(type)
