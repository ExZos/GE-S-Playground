@tool
extends CharacterData

class_name PlayerData

func _get_type_hint_string() -> String:
	return ",".join(RegistryKeys.Players.LIST)
