extends Node

class_name EncounterManager

@export var enemy_manager: EnemyManager

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
	# TODO: determine farthest point from player
	
	for enemy_type: StringName in waves[0].enemies:
		enemy_manager.handle_request(enemy_type, fp_player_pos_x, fp_player_pos_y)
