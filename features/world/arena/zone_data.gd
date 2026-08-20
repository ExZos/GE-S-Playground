@tool
extends Resource

class_name ZoneData

@export var position: Vector2i:
	set(value):
		position = value
		fp_position.x = SGFixed.from_int(value.x)
		fp_position.y = SGFixed.from_int(value.y)

@export var width: int:
	set(value):
		width = value
		fp_width = SGFixed.from_int(value)

@export var height: int:
	set(value):
		height = value
		fp_height = SGFixed.from_int(value)

var fp_position: Vector2i
var fp_width: int
var fp_height: int
