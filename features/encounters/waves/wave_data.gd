@tool
extends RegistryData

# TODO: array of SpawnEvents instead
class_name WaveData

@export var enemies: Array[StringName]

func _validate_property(property: Dictionary) -> void:
	if property.name == "enemies":
		property.hint = PROPERTY_HINT_ARRAY_TYPE
		property.hint_string = "%d/%d:%s" % [TYPE_STRING_NAME, PROPERTY_HINT_ENUM, ",".join(RegistryKeys.Enemies.LIST)]
