extends Resource

class_name ArenaData

@export var half_width: int:
	set(value):
		half_width = value
		fp_half_width = SGFixed.from_int(value)

@export var half_height: int:
	set(value):
		half_height = value
		fp_half_height = SGFixed.from_int(value)

@export var half_bound_thickness: int:
	set(value):
		half_bound_thickness = value
		fp_half_bound_thickness = SGFixed.from_int(value)

@export var zones: Array[ZoneData]

var fp_half_width: int
var fp_half_height: int
var fp_half_bound_thickness: int
