@tool
extends SkillFeature

class_name SpeedFeature

@export var duration: int = 0:
	set(value):
		duration = max(0, value)
		notify_property_list_changed()

@export var speed_mult_inc: int = 1

func get_feature_type() -> StringName:
	return &"speed"
