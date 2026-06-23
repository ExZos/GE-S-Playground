@tool
extends SceneRegistry

class_name VFXRegistry

const SCAN_PATH = RegistryConfig.Paths.VFX_CATALOG

func _validate_property(property: Dictionary) -> void:
	if property.name == "preload_types":
		property.hint = PROPERTY_HINT_ARRAY_TYPE
		property.hint_string = "%d/%d:%s" % [TYPE_STRING_NAME, PROPERTY_HINT_ENUM, ",".join(RegistryKeys.VFX.LIST)]

func _get_scan_path() -> String:
	return SCAN_PATH
