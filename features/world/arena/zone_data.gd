@tool
extends Resource

class_name ZoneData

@export var position: Vector2i:
	set(value):
		position = value
		fp_position.x = SGFixed.from_int(value.x)
		fp_position.y = SGFixed.from_int(value.y)
		_compute_center()

@export var width: int:
	set(value):
		width = value
		fp_width = SGFixed.from_int(value)
		_compute_center()

@export var height: int:
	set(value):
		height = value
		fp_height = SGFixed.from_int(value)
		_compute_center()

var fp_position: Vector2i
var fp_width: int
var fp_height: int

var fp_center: Vector2i

func _compute_center() -> void:
	fp_center.x = fp_position.x + (fp_width / 2)
	fp_center.y = fp_position.y + (fp_height / 2)

func contains_position(fp_pos_x: int, fp_pos_y: int) -> bool:
	return fp_pos_x >= fp_position.x and fp_pos_x < fp_position.x + fp_width and fp_pos_y >= fp_position.y and fp_pos_y < fp_position.y + fp_height
