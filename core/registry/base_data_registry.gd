extends Resource

class_name BaseDataRegistry

var _lookup: Dictionary[StringName, RegistryData] = {}
var is_init: bool = false

func init() -> void:
	if is_init:
		return
	
	var resources: Array = _get_resources()
	for res: RegistryData in resources:
		_lookup[res.type] = res
	
	is_init = true

func _get_resources() -> Array:
	return []

func _get_generic_data(type: StringName) -> RegistryData:
	return _lookup.get(type)
