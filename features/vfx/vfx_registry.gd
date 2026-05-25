extends Resource

class_name VFXRegistry

@export var visual_effects: Array[VFXData]

var _lookup: Dictionary[VFXData.Type, PackedScene] = {}

func init() -> void:
	for effect in visual_effects:
		_lookup[effect.type] = effect.scene

func get_scene(type: VFXData.Type) -> PackedScene:
	return _lookup.get(type)
