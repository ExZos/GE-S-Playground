@tool
extends SkillFeature

class_name RecoveryFeature

@export var recovery: int = 0:
	set(value):
		recovery = max(0, value)

func get_feature_type() -> StringName:
	return &"recovery"
