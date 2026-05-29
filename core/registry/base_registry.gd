extends Resource

class_name BaseRegistry

var _lookup: Dictionary = {}
var is_init: bool = false

func init() -> void:
	if is_init:
		return
	
	var resources: Array = _get_resources()
	for res: RegistryData in resources:
		_lookup[res.id] = res
	
	is_init = true

func _get_resources() -> Array:
	return []

func _get_generic_data(id: int) -> RegistryData:
	return _lookup.get(id)
