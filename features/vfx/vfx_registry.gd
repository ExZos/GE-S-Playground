extends BaseRegistry

class_name VFXRegistry

@export var registry_data: Array[VFXData]

func _get_resources() -> Array[VFXData]:
	return registry_data

func get_scene(type: VFXData.Type) -> PackedScene:
	return _get_generic_scene(type)
