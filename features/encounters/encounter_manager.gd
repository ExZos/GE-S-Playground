extends Node

class_name EncounterManager

@export var arena: Arena
@export var enemy_manager: EnemyManager

@export var spawn_area: SGArea2D
@export var spawn_collision_shape: SGCollisionShape2D

var current_wave: int = 0
var waves: Array[WaveData] = []

var zone_indexes: DenseFixedArray

func init(data: EncounterData) -> void:
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
	var wave: WaveData = waves[current_wave]
	
	zone_indexes = arena.get_zones_not_containing(fp_player_pos_x, fp_player_pos_y)
	
	var current_enemy: int = 0
	var total_wave_enemies: int = wave.enemies.size()
	
	var enemy_distribution: int = total_wave_enemies / zone_indexes.count
	var enemy_remainder: int = total_wave_enemies % zone_indexes.count
	
	for i in range(zone_indexes.count):
		var fp_spawn_point: SGFixedVector2 = arena.get_farthest_zone_point_from(zone_indexes.data[i], fp_player_pos_x, fp_player_pos_y)
	
		# TODO: determine general spawn offset maybe with wave data? or a universal offset?
		fp_spawn_point.x += SGFixed.from_int(150) * -_get_sign(fp_spawn_point.x)
		fp_spawn_point.y += SGFixed.from_int(150) * -_get_sign(fp_spawn_point.y)
		
		var total_zone_enemies: int = enemy_distribution
		if enemy_remainder > 0:
			total_zone_enemies += 1
			enemy_remainder -= 1
		
		var fp_distr_angle: int = SGFixed.TAU / total_zone_enemies
		var fp_current_angle: int = 0
		
		for current_zone_enemy in range(total_zone_enemies):
			var enemy_type: StringName = wave.enemies[current_enemy]
			
			var enemy_data: EnemyData = RegistryManager.get_enemy_data(enemy_type)
			if not enemy_data:
				push_warning("EncounterManager: Enemy type '%s' not recognized" % enemy_type)
				continue
			
			fp_current_angle += fp_distr_angle
			var fp_cos: int = SGFixed.cos(fp_current_angle)
			var fp_sin: int = SGFixed.sin(fp_current_angle)
			
			var fp_spawn_offset_x: int = SGFixed.mul(fp_cos, enemy_data.fp_half_width * 2)
			var fp_spawn_offset_y: int = SGFixed.mul(fp_sin, enemy_data.fp_half_height * 2)
			
			enemy_manager.handle_request(enemy_type, fp_spawn_point.x + fp_spawn_offset_x, fp_spawn_point.y + fp_spawn_offset_y)
			
			current_enemy += 1
			
			# TODO: handle spawn overlapping
			#var pos_x_offset: int = pos_x_offset_mod * enemy_data.fp_half_width
			#var pos_y_offset: int = pos_y_offset_mod * enemy_data.fp_half_height
			#
			#spawn_collision_shape.shape.extents.x = enemy_data.fp_half_width
			#spawn_collision_shape.shape.extents.y = enemy_data.fp_half_height
			#spawn_area.fixed_position.x = fp_spawn_point.x + pos_x_offset
			#spawn_area.fixed_position.y = fp_spawn_point.y + pos_y_offset
			#spawn_area.sync_to_physics_engine()
			
			# TODO: set area to not overlap with projectiles
			#var retries: int = 0
			#while spawn_area.get_overlapping_body_count() > 0:
				## TODO: method that doesn't require a manual fallback break
				#if retries > 100:
					#print("abort")
					#break
				#
				#spawn_area.fixed_position_x += pos_x_offset
				#spawn_area.fixed_position_y += pos_y_offset
				#spawn_area.sync_to_physics_engine()
				#
				#retries += 1
			#
			#enemy_manager.handle_request(enemy_type, spawn_area.fixed_position_x, spawn_area.fixed_position_y)
	
	current_wave = (current_wave + 1) % waves.size()

func _get_sign(n: int) -> int:
	if n > 0:
		return 1
	elif n < 0:
		return -1
	
	return 0
