extends Node

class_name ProjectileManager

# Solid projectile pools
var _solid_inactive: Dictionary[StringName, SparseFixedArray] = {}
var _solid_active: SparseFixedArray

# Sensor projectile pools
var _sensor_inactive: Dictionary[StringName, SparseFixedArray] = {}
var _sensor_active: SparseFixedArray

func advance_frame() -> void:
	_process_pool(_solid_inactive, _solid_active)
	_process_pool(_sensor_inactive, _sensor_active)

func init(projectile_types: Array[StringName]) -> void:
	var largest_pool: Dictionary[int, int] = {
		ProjectileData.Base.SOLID: 0,
		ProjectileData.Base.SENSOR: 0
	}
	
	for type: StringName in projectile_types:
		var projectile_data: ProjectileData = RegistryManager.get_projectile_data(type)
		if not projectile_data:
			push_warning("ProjectileManager: Projectile type '%s' not recognized" % type)
			continue
		
		var typed_inactive_pool: SparseFixedArray
		
		# Determine inactive pool to fill
		var projectile_base: int = projectile_data.base
		if projectile_base == ProjectileData.Base.SOLID:
			if not _solid_inactive.has(projectile_data.type):
				_solid_inactive[projectile_data.type] = SparseFixedArray.new(0, SolidProjectile)
			
			typed_inactive_pool = _solid_inactive[projectile_data.type]
		elif projectile_base == ProjectileData.Base.SENSOR:
			if not _sensor_inactive.has(projectile_data.type):
				_sensor_inactive[projectile_data.type] = SparseFixedArray.new(0, SensorProjectile)
			
			typed_inactive_pool = _sensor_inactive[projectile_data.type]
		else:
			push_error("ProjectileManager: Projectile base '%d' not recognized" %  projectile_base)
			return
		
		# Fill projectile's inactive pool
		typed_inactive_pool.data.resize(typed_inactive_pool.max_size + projectile_data.pool_size)
		typed_inactive_pool.max_size += projectile_data.pool_size
		for i in range(projectile_data.pool_size):
			var projectile: SGFixedNode2D = projectile_data.scene.instantiate()
			
			projectile.init(projectile_data)
			projectile.deactivate()
			projectile.reset()
			
			typed_inactive_pool.data[i] = projectile
			add_child(projectile)
		
		typed_inactive_pool.count += projectile_data.pool_size
		
		# Keep track of largest pool per base
		if largest_pool[projectile_base] < typed_inactive_pool.max_size: 
			largest_pool[projectile_base] = typed_inactive_pool.max_size
	
	_solid_active = SparseFixedArray.new(largest_pool[ProjectileData.Base.SOLID], SolidProjectile)
	_sensor_active = SparseFixedArray.new(largest_pool[ProjectileData.Base.SENSOR], SensorProjectile)

func handle_requests(requests: DenseFixedArray) -> void:
	for i in range(requests.count):
		var req: ProjectileRequest = requests.data[i]
		var projectile: SGFixedNode2D
	
		# Will point to the arrays for this projectile
		var typed_inactive_pool: SparseFixedArray
		var active_pool: SparseFixedArray
		
		var projectile_data: ProjectileData = RegistryManager.get_projectile_data(req.type)
		if not projectile_data:
			push_warning("ProjectileManager: Projectile type '%s' not recognized" % req.type)
			continue
		
		# Determine which arrays to take from and put into
		var requested_base: ProjectileData.Base = projectile_data.base
		if requested_base == ProjectileData.Base.SOLID:
			typed_inactive_pool = _solid_inactive[req.type]
			active_pool = _solid_active
		elif requested_base == ProjectileData.Base.SENSOR:
			typed_inactive_pool = _sensor_inactive[req.type]
			active_pool = _sensor_active
		else:
			push_error("ProjectileManager: Projectile base '%s' not recognized" % requested_base)
			return
			
		# Get inactive projectile or create one if none available
		var next_filled_index: int = typed_inactive_pool.get_next_filled_index()
		if next_filled_index > -1:
			projectile = typed_inactive_pool.data[next_filled_index]
			typed_inactive_pool.data[next_filled_index] = null
			typed_inactive_pool.count -= 1
			
			projectile.activate(req.source, req.fp_pos_x, req.fp_pos_y, req.dir)
		else:
			projectile = projectile_data.scene.instantiate()
			
			projectile.init(projectile_data)
			projectile.activate(req.source, req.fp_pos_x, req.fp_pos_y, req.dir)
			
			add_child(projectile)
		
		# Get next empty index
		var next_empty_index: int = active_pool.get_next_empty_index()
		if next_empty_index == -1:
			push_warning("ProjectileManager: No active pool space for projectile base '%s', creating one. Total '%s' active pool space: %d" % [requested_base, requested_base, active_pool.max_size])
			active_pool.data.resize(active_pool.max_size + 1)
			active_pool.max_size += 1
		
		active_pool.data[next_empty_index] = projectile
		active_pool.count += 1

func handle_modifiers(modifiers: DenseFixedArray) -> void:
	for i in range(modifiers.count):
		var mod: ProjectileModifier = modifiers.data[i]
		
		mod.apply(_solid_active)
		mod.apply(_sensor_active)
		
		mod.check_applied()

func _process_pool(inactive_pool: Dictionary[StringName, SparseFixedArray], active_pool: SparseFixedArray) -> void:
	for i in range(active_pool.max_size):
		var projectile: SGFixedNode2D = active_pool.data[i]
		if not projectile:
			continue
		
		projectile.advance_frame()
		if projectile.is_deactivated:
			projectile.reset()
			
			active_pool.data[i] = null
			active_pool.count -= 1
			
			var typed_inactive_pool: SparseFixedArray = inactive_pool[projectile.type] 
			var next_empty_index: int = typed_inactive_pool.get_next_empty_index()
			if next_empty_index == -1:
				push_warning("ProjectileManager: No inactive pool space for projectile type '%s', creating one. Total '%s' inactive pool space: %d" % [projectile.type, projectile.type, typed_inactive_pool.max_size])
				typed_inactive_pool.data.resize(typed_inactive_pool.max_size + 1)
				typed_inactive_pool.max_size += 1
			
			typed_inactive_pool.data[next_empty_index] = projectile
			typed_inactive_pool.count += 1
