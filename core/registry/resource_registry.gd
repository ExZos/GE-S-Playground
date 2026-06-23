extends BaseRegistry

class_name ResourceRegistry

const TARGET_EXT: String = RegistryConfig.TargetExtensions.RESOURCE_REGISTRY

var _lookup: Dictionary[StringName, RegistryData] = {}

func _get_target_ext() -> String:
	return TARGET_EXT

func _preload_lookup() -> void:
	for type: StringName in preload_types:
		_lookup[type] = load(_paths.get(type))

func _get_generic_data(type: StringName) -> RegistryData:
	var data: RegistryData = _lookup.get(type, null)
	
	if not data:
		push_error("ResourceRegistry: Resource type '%s' was requested but never preloaded" % type)
		return null
	
	return data

func _get_scan_path() -> String:
	assert(false, "ResourceRegistry: Subclass must override _get_scan_path()")
	return ""
