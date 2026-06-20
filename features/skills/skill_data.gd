@tool
extends RegistryData

class_name SkillData

@export_group("Configuration")
@export var features: Array[SkillFeature]

func _get_type_hint_string() -> String:
	return Type.LIST

class Type extends RefCounted:
	const DASH: StringName = &"Dash"
	const SHOOT_SENSOR: StringName = &"ShootSensor"
	const SHOOT_SOLID: StringName = &"ShootSolid"
	const SPRINT: StringName = &"Sprint"
	const TELEKINESIS: StringName = &"Telekinesis"
	
	const LIST =\
		DASH + "," +\
		SHOOT_SENSOR + "," +\
		SHOOT_SOLID + "," +\
		SPRINT + "," +\
		TELEKINESIS
