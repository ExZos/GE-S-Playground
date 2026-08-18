@tool
extends RegistryData

class_name EnemyData

@export var max_hp: int:
	set(value):
		max_hp = value
		fp_max_hp = SGFixed.from_int(value)

@export var half_width: int:
	set(value):
		half_width = value
		fp_half_width = SGFixed.from_int(value)
		
@export var half_height: int:
	set(value):
		half_height = value
		fp_half_height = SGFixed.from_int(value)

var fp_max_hp: int
var fp_half_width: int
var fp_half_height: int
