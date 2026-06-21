extends Resource

class_name BaseRegistry

@export var preload_types: Array[StringName]

var _paths: Dictionary[StringName, String] = {}
var is_init: bool = false

func init() -> void:
	if Engine.is_editor_hint():
		return
	elif is_init:
		return
	
	_scan_dir(_get_scan_path())
	_preload_lookup()
	
	is_init = true

func _scan_dir(dir_path: String) -> void:
	var files = ResourceLoader.list_directory(dir_path)
	var target_file_end: String = _get_target_file_end()
	
	for file_name: String in files:
		if file_name.ends_with("/"):
			_scan_dir(dir_path.path_join(file_name.trim_suffix("/")))
		elif file_name.ends_with(target_file_end):
			_paths[file_name.get_basename()] = dir_path.path_join(file_name)

func _get_scan_path() -> String:
	assert(false, "BaseRegistry: Subclass must override _get_scan_path()")
	return ""

func _get_target_file_end() -> String:
	assert(false, "BaseRegistry: Subclass must override _get_target_file_end()")
	return ""

func _preload_lookup() -> void:
	assert(false, "BaseRegistry: Subclass must override _preload_lookup()")
