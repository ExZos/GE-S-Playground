extends Node

class_name SGShape2DUtils

static func get_size(shape: SGShape2D, global_scale: Vector2 = Vector2.ONE) -> Vector2:
	if not shape:
		return Vector2.ZERO
	
	var size: Vector2 = Vector2.ZERO
	
	if shape is SGRectangleShape2D:
		size.x = SGFixed.to_int(shape.extents.x) * 2
		size.y = SGFixed.to_int(shape.extents.y) * 2
	
	# TODO: handle other shapes
	
	return size * global_scale
