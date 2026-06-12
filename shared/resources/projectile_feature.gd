extends SkillFeature

class_name ProjectileFeature

@export var projectile_type: ProjectileData.Type = ProjectileData.Type.NONE

func get_feature_type() -> StringName:
	return &"projectile"
