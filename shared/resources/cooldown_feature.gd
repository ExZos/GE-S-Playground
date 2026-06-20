@tool
extends SkillFeature

class_name CooldownFeature

const TYPE: StringName = &"cooldown"

@export var cooldown: int = 60:
	set(value):
		cooldown = max(0, value)
		notify_property_list_changed()

func get_feature_type() -> StringName:
	return TYPE
