@tool
extends CharacterData

class_name EnemyData

# TODO: move cooldown with duration leading to idle time
@export var min_move_duration: int:
	set(value):
		min_move_duration = value
		fp_min_move_duration = SGFixed.from_int(value)

@export var max_move_duration: int:
	set(value):
		max_move_duration = value
		fp_max_move_duration = SGFixed.from_int(value)

@export var min_attack_cooldown: int:
	set(value):
		min_attack_cooldown = value
		fp_min_attack_cooldown = SGFixed.from_int(value)

@export var max_attack_cooldown: int:
	set(value):
		max_attack_cooldown = value
		fp_max_attack_cooldown = SGFixed.from_int(value)

var fp_min_move_duration: int
var fp_max_move_duration: int

var fp_min_attack_cooldown: int
var fp_max_attack_cooldown: int

func _get_type_hint_string() -> String:
	return ",".join(RegistryKeys.Enemies.LIST)
