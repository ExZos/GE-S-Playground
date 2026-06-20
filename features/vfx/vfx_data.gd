@tool
extends RegistryData

class_name VFXData

func _get_type_hint_string() -> String:
	return Type.LIST

class Type extends RefCounted:
	const BUBBLE_VFX: StringName = &"BubbleVFX"
	
	const LIST =\
		BUBBLE_VFX
