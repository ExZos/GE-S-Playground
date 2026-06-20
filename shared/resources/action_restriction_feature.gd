extends SkillFeature

class_name ActionRestrictionFeature

const TYPE: StringName = &"action_restriction"

@export_range(0, 1) var speed_mult_prod_inc: float = 1
@export var restrict_attack: bool = false
@export var restrict_skills: bool = false

func get_feature_type() -> StringName:
	return TYPE
