extends SkillFeature

class_name ProjectileFeature

const TYPE: StringName = &"projectile"

@export_custom(PROPERTY_HINT_ENUM, ProjectileData.Type.LIST) var projectile_type: StringName

func get_feature_type() -> StringName:
	return TYPE
