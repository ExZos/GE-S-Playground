@tool
extends SkillFeature

class_name CooldownFeature

@export var cooldown: int = 60:
	set(value):
		cooldown = max(0, value)
		notify_property_list_changed()

func get_feature_type() -> StringName:
	return &"cooldown"
