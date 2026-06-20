extends Resource

class_name SkillFeature

func get_feature_type() -> StringName:
	assert(false, "SkillFeature: Subclass must override get_feature_type()")
	return &"UNKNOWN"
