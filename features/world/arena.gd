extends SGFixedNode2D

class_name Arena

@export var top_bound: SGCollisionShape2D
@export var left_bound: SGCollisionShape2D
@export var right_bound: SGCollisionShape2D
@export var bottom_bound: SGCollisionShape2D

@export var width: int = 2304
@export var height: int = 1300
@export var bound_thickness: int = 200

var fp_width: int
var fp_height: int
var fp_bound_thickness: int

var arena_rect: SGFixedRect2

func init() -> void:
	fp_width = SGFixed.from_int(width)
	fp_height = SGFixed.from_int(height)
	fp_bound_thickness = SGFixed.from_int(bound_thickness)
	
	var fp_half_width: int = fp_width / 2
	var fp_half_height: int = fp_height / 2
	var fp_half_bound_thickness: int = fp_bound_thickness / 2
	
	arena_rect = SGFixedRect2.new()
	arena_rect.position = SGFixed.vector2(-fp_half_width, -fp_half_height)
	arena_rect.size = SGFixed.vector2(fp_width, fp_height)
	
	top_bound.fixed_position_x = 0
	top_bound.fixed_position_y = -fp_half_height - fp_half_bound_thickness
	top_bound.shape.extents.x = fp_half_width + fp_bound_thickness
	top_bound.shape.extents.y = fp_half_bound_thickness
	
	bottom_bound.fixed_position_x = 0
	bottom_bound.fixed_position_y = fp_half_height + fp_half_bound_thickness
	bottom_bound.shape.extents.x = fp_half_width + fp_bound_thickness
	bottom_bound.shape.extents.y = -fp_half_bound_thickness
	
	left_bound.fixed_position_x = -fp_half_width - fp_half_bound_thickness
	left_bound.fixed_position_y = 0
	left_bound.shape.extents.x = fp_half_bound_thickness
	left_bound.shape.extents.y = fp_half_height + fp_bound_thickness
	
	right_bound.fixed_position_x = fp_half_width + fp_half_bound_thickness
	right_bound.fixed_position_y = 0
	right_bound.shape.extents.x = -fp_half_bound_thickness
	right_bound.shape.extents.y = fp_half_height + fp_bound_thickness

func get_farthest_point_from(fp_pos_x: int, fp_pos_y: int) -> SGFixedVector2:
	var farthest_point: SGFixedVector2 = SGFixedVector2.new()
	
	if fp_pos_x > 0:
		farthest_point.x = arena_rect.position.x
	else:
		farthest_point.x = arena_rect.position.x + arena_rect.size.x
	
	if fp_pos_y > 0:
		farthest_point.y = arena_rect.position.y
	else:
		farthest_point.y = arena_rect.position.y + arena_rect.size.y
	
	return farthest_point
