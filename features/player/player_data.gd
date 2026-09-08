@tool
extends Resource

class_name PlayerData

@export var max_hp: int:
	set(value):
		max_hp = value
		fp_max_hp = SGFixed.from_int(value)

@export var base_speed: int:
	set(value):
		base_speed = value
		fp_base_speed = SGFixed.from_int(value)

var fp_max_hp: int
var fp_base_speed: int
