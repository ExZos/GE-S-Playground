extends Node

class_name EnemyManager

const PROJECTILE_REQUESTS_POOL_SIZE: int = 5

var _enemy_pool: SparseTypedFixedArray

var _input_masks: PackedInt32Array
var _prev_input_masks: PackedInt32Array

# 
var projectile_requests: DenseFixedArray

func init(enemy_types: Array[StringName]) -> void:
	EventBus.register_enemy_manager(self)
	
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
	
	_input_masks = PackedInt32Array()
	_input_masks.resize(_enemy_pool.max_size)
	_prev_input_masks = PackedInt32Array()
	_prev_input_masks.resize(_enemy_pool.max_size)
	
	projectile_requests = DenseFixedArray.new(PROJECTILE_REQUESTS_POOL_SIZE, TYPE_OBJECT, ProjectileRequest)

func read_input_masks() -> void:
	for i in range(_enemy_pool.active_list_count - 1, -1, -1):
		_prev_input_masks[i] = _input_masks[i]
		
		var enemy: Enemy = _enemy_pool.get_nth_active_item(i)
		
		_input_masks[i] = enemy.get_input_mask(_input_masks[i])

func advance_frame() -> void:
	for i in range(_enemy_pool.active_list_count - 1, -1, -1):
		var enemy: Enemy = _enemy_pool.get_nth_active_item(i)
		
		enemy.advance_frame(_input_masks[i], _prev_input_masks[i])
		if enemy.get_slide_count() > 0:
			_input_masks[i] = enemy.handle_collision(_input_masks[i])
			print("COLLISION")
			
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
		
		# Expand input mask arrays
		_input_masks.resize(_enemy_pool.max_size)
		_prev_input_masks.resize(_enemy_pool.max_size)

# --- Projectile request wrappers ---
func add_projectile_request(request: ProjectileRequest) -> void:
	if projectile_requests.add_item(request) == -1:
		projectile_requests.forced_expand("EnemyManager -> Projectile requests", 1)
		
		projectile_requests.add_item(request)

func clear_projectile_requests() -> void:
	projectile_requests.clear_data()
