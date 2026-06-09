extends RegistryData

class_name VFXData

# Next id: 1
enum Type {
	NONE = -1,
	BUBBLE_VFX = 0
}

@export var type: Type:
	set(value):
		type = value
		id = value
