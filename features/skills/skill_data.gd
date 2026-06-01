extends RegistryData

class_name SkillData

enum Type {
	NONE,
	SHOOT_SENSOR,
	SHOOT_SOLID,
	SPRINT,
	TELEKINESIS
}

@export var type: Type:
	set(value):
		type = value
		id = value
