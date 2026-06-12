@tool
extends SkillFeature

class_name CooldownFeature

@export var cooldown: int = 60:
	set(value):
		cooldown = max(0, value)

func get_feature_type() -> StringName:
	return &"cooldown"
