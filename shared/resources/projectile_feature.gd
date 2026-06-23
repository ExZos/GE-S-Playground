@tool
extends SkillFeature

class_name ProjectileFeature

const TYPE: StringName = &"projectile"

@export var projectile_type: StringName

func _validate_property(property: Dictionary) -> void:
	if property.name == "projectile_type":
		property.hint = PropertyHint.PROPERTY_HINT_ENUM
		property.hint_string = ",".join(RegistryKeys.Projectiles.LIST)

func get_feature_type() -> StringName:
	return TYPE
