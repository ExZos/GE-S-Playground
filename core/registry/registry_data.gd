extends Resource

class_name RegistryData

@export var type: StringName
@export var scene: PackedScene: set = _set_scene

func _validate_property(property: Dictionary):
	if property.name == "type":
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = _get_type_hint_string()

func _get_type_hint_string() -> String:
	return ""

func _set_scene(value: PackedScene) -> void:
	scene = value
