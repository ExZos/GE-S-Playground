extends RegistryData

class_name VFXData

enum Type {
	NONE,
	TELEKINESIS
}

@export var type: Type:
	set(value):
		type = value
		id = value
