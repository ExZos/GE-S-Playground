@tool
extends CharacterData

class_name EnemyData

@export var min_action_duration: int:
	set(value):
		min_action_duration = value
		fp_min_action_duration = SGFixed.from_int(value)

@export var max_action_duration: int:
	set(value):
		max_action_duration = value
		fp_max_action_duration = SGFixed.from_int(value)

@export var half_width: int:
	set(value):
		half_width = value
		fp_half_width = SGFixed.from_int(value)
		fp_width = fp_half_width * 2
		
@export var half_height: int:
	set(value):
		half_height = value
		fp_half_height = SGFixed.from_int(value)
		fp_height = fp_half_height * 2

var fp_min_action_duration: int
var fp_max_action_duration: int

var fp_half_width: int
var fp_half_height: int
var fp_width: int
var fp_height: int

func _get_type_hint_string() -> String:
	return ",".join(RegistryKeys.Enemies.LIST)
