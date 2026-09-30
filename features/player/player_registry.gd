@tool
extends ResourceRegistry

class_name PlayerRegistry

const SCAN_PATH = RegistryConfig.Paths.PLAYERS_CATALOG

func _validate_property(property: Dictionary) -> void:
	if property.name == "preload_types":
		property.hint = PROPERTY_HINT_ARRAY_TYPE
		property.hint_string = "%d/%d:%s" % [TYPE_STRING_NAME, PROPERTY_HINT_ENUM, ",".join(RegistryKeys.Players.LIST)]

func _get_scan_path() -> String:
	return SCAN_PATH

func get_data(type: StringName) -> PlayerData:
	return _get_generic_data(type)
