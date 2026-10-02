extends RegistryData

class_name CharacterData

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

@export var max_hp: int:
	set(value):
		max_hp = value
		fp_max_hp = SGFixed.from_int(value)

@export var base_speed: int:
	set(value):
		base_speed = value
		fp_base_speed = SGFixed.from_int(value)

var fp_half_width: int
var fp_half_height: int
var fp_width: int
var fp_height: int

var fp_max_hp: int
var fp_base_speed: int
