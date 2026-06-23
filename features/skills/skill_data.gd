@tool
extends RegistryData

class_name SkillData

@export_group("Configuration")
@export var features: Array[SkillFeature]

func _get_type_hint_string() -> String:
	return ",".join(RegistryKeys.Skills.LIST)
