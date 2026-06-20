@tool
extends RegistryData

class_name SkillData

@export_group("Configuration")
@export var features: Array[SkillFeature]

func _get_type_hint_string() -> String:
	return Type.LIST

class Type extends RefCounted:
	const DASH: StringName = &"dash"
	const SHOOT_SENSOR: StringName = &"shoot_sensor"
	const SHOOT_SOLID: StringName = &"shoot_solid"
	const SPRINT: StringName = &"sprint"
	const TELEKINESIS: StringName = &"telekinesis"
	
	const LIST =\
		DASH + "," +\
		SHOOT_SENSOR + "," +\
		SHOOT_SOLID + "," +\
		SPRINT + "," +\
		TELEKINESIS
