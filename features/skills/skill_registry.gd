extends BaseRegistry

class_name SkillRegistry

@export var skill_data: Array[SkillData]

func _get_resources() -> Array:
	return skill_data

func get_scene(type: SkillData.Type) -> PackedScene:
	return _lookup.get(type)
