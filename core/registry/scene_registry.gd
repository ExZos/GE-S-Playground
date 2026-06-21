extends BaseRegistry

class_name SceneRegistry

const TARGET_FILE_END: String = ".tscn"

var _lookup: Dictionary[StringName, PackedScene] = {}

func _get_target_file_end() -> String:
	return TARGET_FILE_END

func _preload_lookup() -> void:
	for type: StringName in preload_types:
		_lookup[type] = load(_paths.get(type))

func get_scene(type: StringName) -> PackedScene:
	var scene: PackedScene = _lookup.get(type, null)
	
	if not scene:
		push_error("SceneRegistry: Scene type '%s' was requested but never preloaded" % type)
		return null
	
	return _lookup.get(type)

func _get_scan_path() -> String:
	assert(false, "SceneRegistry: Subclass must override _get_scan_path()")
	return ""
