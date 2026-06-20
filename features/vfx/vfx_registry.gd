@tool
extends BaseSceneRegistry

class_name VFXRegistry

const scan_path = "res://features/vfx/catalog"

func _validate_property(property: Dictionary) -> void:
	if property.name == "preloads":
		property.hint = PROPERTY_HINT_ARRAY_TYPE
		property.hint_string = "%d/%d:%s" % [TYPE_STRING_NAME, PROPERTY_HINT_ENUM, VFXData.Type.LIST]

func get_scan_path() -> String:
	return scan_path
