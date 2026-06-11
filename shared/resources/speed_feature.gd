extends SkillFeature

class_name SpeedFeature

@export var speed_mult_inc: int = 1

func get_feature_type() -> StringName:
	return &"speed"
