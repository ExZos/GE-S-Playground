extends BaseRegistry

class_name SkillRegistry

@export var skill_data: Array[SkillData]

func _get_resources() -> Array:
	return skill_data

func get_data(type: StringName) -> SkillData:
	return _lookup.get(type)
