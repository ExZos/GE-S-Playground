@tool
extends SkillFeature

class_name SpeedFeature

const TYPE: StringName = &"speed"

@export var duration: int = 0:
	set(value):
		duration = max(0, value)
		notify_property_list_changed()

@export var speed_add_inc: int = 0
@export var speed_mult_sum_inc: int = 0
@export var speed_mult_prod_inc: float = 1

func get_feature_type() -> StringName:
	return TYPE
