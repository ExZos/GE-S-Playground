extends Node

class_name ProjectileManager

var _solid_pool: SparseTypedFixedArray
var _sensor_pool: SparseTypedFixedArray

func advance_frame() -> void:
	_process_pool(_solid_pool)
	_process_pool(_sensor_pool)

func init(projectile_types: Array[StringName]) -> void:
	var projectiles_by_base_and_type: Dictionary[int, Dictionary] = {
		ProjectileData.Base.SOLID: {},
		ProjectileData.Base.SENSOR: {}
	}
	
	var pool_sizes_by_base: Dictionary[int, int] = {
		ProjectileData.Base.SOLID: 0,
		ProjectileData.Base.SENSOR: 0
	}
	
	for type: StringName in projectile_types:
		var projectile_data: ProjectileData = RegistryManager.get_projectile_data(type)
		if not projectile_data:
			push_warning("ProjectileManager: Projectile type '%s' not recognized" % type)
			continue
		
		var projectiles_by_type: Dictionary = projectiles_by_base_and_type[projectile_data.base] # Dictionary[StringName, int]
		if not projectiles_by_type.has(projectile_data.type):
			projectiles_by_type[projectile_data.type] = []
		
		for i in range(projectile_data.pool_size):
			var projectile: SGFixedNode2D = projectile_data.scene.instantiate()
			
			projectile.init(projectile_data)
			projectile.deactivate()
			projectile.reset()
			
			projectiles_by_type[projectile_data.type].append(projectile)
			add_child(projectile)
		
		pool_sizes_by_base[projectile_data.base] += projectile_data.pool_size
	
	_solid_pool = SparseTypedFixedArray.new(pool_sizes_by_base[ProjectileData.Base.SOLID], SolidProjectile, projectiles_by_base_and_type[ProjectileData.Base.SOLID])
	_sensor_pool = SparseTypedFixedArray.new(pool_sizes_by_base[ProjectileData.Base.SENSOR], SensorProjectile, projectiles_by_base_and_type[ProjectileData.Base.SENSOR])

func handle_requests(requests: DenseFixedArray) -> void:
	for i in range(requests.count):
		var req: ProjectileRequest = requests.data[i]
	
		# Will point to the pool for this projectile
		var projectile_pool: SparseTypedFixedArray
		
		var projectile_data: ProjectileData = RegistryManager.get_projectile_data(req.type)
		if not projectile_data:
			push_warning("ProjectileManager: Projectile type '%s' not recognized" % req.type)
			continue
		
		# Determine which arrays to take from and put into
		var requested_base: ProjectileData.Base = projectile_data.base
		if requested_base == ProjectileData.Base.SOLID:
			projectile_pool = _solid_pool
		elif requested_base == ProjectileData.Base.SENSOR:
			projectile_pool = _sensor_pool
		else:
			push_error("ProjectileManager: Projectile base '%s' not recognized" % requested_base)
			return
			
		# Get inactive projectile or create one if none available
		var projectile: SGFixedNode2D = projectile_pool.reserve_typed_item(projectile_data.type)
		if projectile:
			projectile.activate(req.source, req.fp_pos_x, req.fp_pos_y, req.dir)
		else:
			# Expand pool and manually fill
			var old_pool_max_size: int = projectile_pool.max_size
			projectile_pool.forced_expand("ProjectileManager -> Projectile base '%s'" % projectile_data.base, 1, projectile_data.type)
			for j in range(old_pool_max_size, projectile_pool.max_size):
				projectile = projectile_data.scene.instantiate()
				
				projectile.init(projectile_data)
				projectile.activate(req.source, req.fp_pos_x, req.fp_pos_y, req.dir)
				
				projectile_pool.data[j] = projectile
				add_child(projectile)
				projectile_pool.reserve_typed_item(projectile_data.type)

func handle_modifiers(modifiers: DenseFixedArray) -> void:
	for i in range(modifiers.count):
		var mod: ProjectileModifier = modifiers.data[i]
		
		mod.apply(_solid_pool)
		mod.apply(_sensor_pool)
		
		mod.check_applied()

func _process_pool(projectile_pool: SparseTypedFixedArray) -> void:
	for i in range(projectile_pool.active_list_count - 1, -1, -1):
		var projectile: SGFixedNode2D = projectile_pool.data[projectile_pool.active_list[i]]
		
		projectile.advance_frame()
		if not projectile.is_active:
			projectile.reset()
			
			projectile_pool.free_typed_item(projectile.type, projectile_pool.active_list[i])
