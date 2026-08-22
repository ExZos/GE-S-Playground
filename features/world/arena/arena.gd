extends SGFixedNode2D

class_name Arena

@export var top_bound: SGCollisionShape2D
@export var left_bound: SGCollisionShape2D
@export var right_bound: SGCollisionShape2D
@export var bottom_bound: SGCollisionShape2D

@export var arena_data: ArenaData

var arena_rect: SGFixedRect2

var zone_indexes: DenseFixedArray

func init() -> void:
	var fp_half_width: int = arena_data.fp_half_width
	var fp_width: int = arena_data.fp_half_width * 2
	
	var fp_half_height: int = arena_data.fp_half_height
	var fp_height: int = arena_data.fp_half_height * 2
	
	var fp_half_bound_thickness: int = arena_data.fp_half_bound_thickness
	var fp_bound_thickness: int = arena_data.fp_half_bound_thickness * 2
	
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
	
	zone_indexes = DenseFixedArray.new(arena_data.zones.size(), TYPE_INT)

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

func get_zones_not_containing(fp_pos_x: int, fp_pos_y: int) -> DenseFixedArray:
	zone_indexes.clear_data()
	
	for i: int in range(arena_data.zones.size()):
		var zone: ZoneData = arena_data.zones[i]
		
		if zone.contains_position(fp_pos_x, fp_pos_y):
			continue
		
		zone_indexes.add_item(i)
	
	return zone_indexes

func get_farthest_zone_point_from(zone_index: int, fp_pos_x: int, fp_pos_y: int) -> SGFixedVector2:
	var zone: ZoneData = arena_data.zones[zone_index]
	
	var farthest_point: SGFixedVector2 = SGFixedVector2.new()
	
	if fp_pos_x > zone.fp_center.x:
		farthest_point.x = zone.fp_position.x
	else:
		farthest_point.x = zone.fp_position.x + zone.fp_width
	
	if fp_pos_y > zone.fp_center.y:
		farthest_point.y = zone.fp_position.y
	else:
		farthest_point.y = zone.fp_position.y + zone.fp_height
	
	return farthest_point
