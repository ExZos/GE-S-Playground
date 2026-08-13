@tool
extends Resource

class_name EncounterData

@export var waves: Array[StringName]

func _validate_property(property: Dictionary) -> void:
	if property.name == "waves":
		property.hint = PROPERTY_HINT_ARRAY_TYPE
		property.hint_string = "%d/%d:%s" % [TYPE_STRING_NAME, PROPERTY_HINT_ENUM, ",".join(RegistryKeys.Waves.LIST)]
