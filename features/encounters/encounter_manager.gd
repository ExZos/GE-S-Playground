extends Node

class_name EncounterManager

@export var arena: Arena
@export var enemy_manager: EnemyManager

@export var spawn_area: SGArea2D
@export var spawn_collision_shape: SGCollisionShape2D

var waves: Array[WaveData] = []

func init(data: EncounterData) -> void:
	# TODO: count enemy_type occurence in encounter too (account for max enemies on screen too)
	var enemy_types: Array[StringName] = []
	
	for wave_type: StringName in data.waves:
		var wave_data: WaveData = RegistryManager.get_wave_data(wave_type)
		if not wave_data:
			push_warning("EncounterManager: Wave type '%s' not recognized" % wave_type)
			continue
			
		waves.append(wave_data)
		
		for enemy_type: StringName in wave_data.enemies:
			enemy_types.append(enemy_type)
	
	enemy_manager.init(enemy_types)

func spawn_wave(fp_player_pos_x: int, fp_player_pos_y: int) -> void:
	var fp_spawn_point: SGFixedVector2 = arena.get_farthest_point_from(fp_player_pos_x, fp_player_pos_y)
	
	var pos_x_offset_mod: int = -_get_sign(fp_spawn_point.x)
	var pos_y_offset_mod: int = -_get_sign(fp_spawn_point.y)
	
	for enemy_type: StringName in waves[0].enemies:
		var enemy_data: EnemyData = RegistryManager.get_enemy_data(enemy_type)
		if not enemy_data:
			push_warning("EncounterManager: Enemy type '%s' not recognized" % enemy_type)
			continue
		
		var pos_x_offset: int = pos_x_offset_mod * enemy_data.fp_half_width
		var pos_y_offset: int = pos_y_offset_mod * enemy_data.fp_half_height
		
		spawn_collision_shape.shape.extents.x = enemy_data.fp_half_width
		spawn_collision_shape.shape.extents.y = enemy_data.fp_half_height
		spawn_area.fixed_position.x = fp_spawn_point.x + pos_x_offset
		spawn_area.fixed_position.y = fp_spawn_point.y + pos_y_offset
		spawn_area.sync_to_physics_engine()
		
		# TODO: set area to not overlap with projectiles
		# TODO: find a way to alternate spawn offset between x and y
		var retries: int = 0
		while spawn_area.get_overlapping_body_count() > 0:
			# TODO: method that doesn't require a manual fallback break
			if retries > 100:
				print("abort")
				break
			
			spawn_area.fixed_position_x += pos_x_offset
			spawn_area.fixed_position_y += pos_y_offset
			spawn_area.sync_to_physics_engine()
			
			retries += 1
		
		enemy_manager.handle_request(enemy_type, spawn_area.fixed_position_x, spawn_area.fixed_position_y)

func _get_sign(n: int) -> int:
	if n > 0:
		return 1
	elif n < 0:
		return -1
	
	return 0
