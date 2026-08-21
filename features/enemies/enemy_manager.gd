extends Node

class_name EnemyManager

var _enemy_pool: SparseTypedFixedArray

func init(enemy_types: Array[StringName]) -> void:
	var enemies_by_type: Dictionary = {} # Dictionary[StringName, Array]
	
	for type: StringName in enemy_types:
		var enemy_data: EnemyData = RegistryManager.get_enemy_data(type)
		if not enemy_data:
			push_warning("EnemyManager: Enemy type '%s' not recognized" % type)
			continue
		
		var enemy: Enemy = enemy_data.scene.instantiate()
		
		enemy.init(enemy_data)
		enemy.deactivate()
		enemy.reset()
		
		if not enemies_by_type.has(type):
			enemies_by_type[type] = []
		
		enemies_by_type[type].append(enemy)
		add_child(enemy)
	
	_enemy_pool = SparseTypedFixedArray.new(enemy_types.size(), Enemy, enemies_by_type)

func advance_frame() -> void:
	for i in range(_enemy_pool.active_list_count - 1, -1, -1):
		var enemy: Enemy = _enemy_pool.get_nth_active_item(i)
		
		enemy.advance_frame()
		if enemy.is_dead:
			enemy.deactivate()
			enemy.reset()
			
			_enemy_pool.free_typed_item(enemy.type, _enemy_pool.active_list[i])

func handle_request(enemy_type: StringName, fp_pos_x: int, fp_pos_y: int) -> void:
	var enemy: Enemy = _enemy_pool.reserve_typed_item(enemy_type)
	if enemy:
		enemy.activate(fp_pos_x , fp_pos_y)
	else:
		# Expand pool and manually fill
		var old_pool_max_size: int = _enemy_pool.max_size
		_enemy_pool.forced_expand("EnemyManager", 1, enemy_type)
		for j in range(old_pool_max_size, _enemy_pool.max_size):
			var enemy_data: EnemyData = RegistryManager.get_enemy_data(enemy_type)
			if not enemy_data:
				push_warning("EnemyManager: Enemy type '%s' not recognized" % enemy_type)
				return
			
			enemy = enemy_data.scene.instantiate()
			
			enemy.init(enemy_data)
			enemy.activate(fp_pos_x , fp_pos_y)
			
			_enemy_pool.data[j] = enemy
			add_child(enemy)
			_enemy_pool.reserve_typed_item(enemy_type)
