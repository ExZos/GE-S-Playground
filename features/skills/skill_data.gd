extends RegistryData

class_name SkillData

# Next id: 5
enum Type {
	NONE = -1,
	DASH = 4,
	SHOOT_SENSOR = 1,
	SHOOT_SOLID = 2,
	SPRINT = 0,
	TELEKINESIS = 3
}

@export_group("Core")
@export var type: Type:
	set(value):
		type = value
		id = value

@export_group("Features")
@export var features: Array[SkillFeature]
