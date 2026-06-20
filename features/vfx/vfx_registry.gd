extends BaseRegistry

class_name VFXRegistry

@export var registry_data: Array[VFXData]

func _get_resources() -> Array[VFXData]:
	return registry_data

func get_data(type: StringName) -> RegistryData:
	return _get_generic_data(type)
