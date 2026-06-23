@tool
extends RegistryData

class_name VFXData

func _get_type_hint_string() -> String:
	return ",".join(RegistryKeys.VFX.LIST)
