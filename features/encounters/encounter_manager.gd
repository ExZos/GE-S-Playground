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
	
	# TODO: handle clipping out of bounds on spawn
	for enemy_type: StringName in waves[0].enemies:
		var enemy_data: EnemyData = RegistryManager.get_enemy_data(enemy_type)
		if not enemy_data:
			push_warning("EncounterManager: Enemy type '%s' not recognized" % enemy_type)
			continue
		
		spawn_area.fixed_position = fp_spawn_point # TODO: adjust position based on enemy size
		spawn_collision_shape.shape.extents.x = SGFixed.from_int(enemy_data.width)
		spawn_collision_shape.shape.extents.y = SGFixed.from_int(enemy_data.height)
		spawn_area.sync_to_physics_engine()
		
		if spawn_area.get_overlapping_bodies().size() > 0:
			print("OVERLAP")
			#continue
		
		enemy_manager.handle_request(enemy_type, fp_spawn_point.x, fp_spawn_point.y)
