extends Node

class_name ProjectileManager

# Solid projectile pools
var _solid_inactive: Dictionary[StringName, Array] = {}
var _solid_active: Array[SolidProjectile] = []

# Sensor projectile pools
var _sensor_inactive: Dictionary[StringName, Array] = {}
var _sensor_active: Array[SensorProjectile] = []

func advance_frame() -> void:
	_process_pool(_solid_inactive, _solid_active)
	_process_pool(_sensor_inactive, _sensor_active)

func init(projectile_types: Array[StringName]) -> void:
	for type: StringName in projectile_types:
		var projectile_data: ProjectileData = RegistryManager.get_projectile_data(type)
		if not projectile_data:
			push_warning("ProjectileManager: Projectile type '%s' not recognized" % type)
			continue
		
		var inactive_pool: Dictionary[StringName, Array]
		
		# Determine inactive pool to fill
		var projectile_base = projectile_data.base
		if projectile_base == ProjectileData.Base.SOLID:
			inactive_pool = _solid_inactive
		elif projectile_base == ProjectileData.Base.SENSOR:
			inactive_pool = _sensor_inactive
		else:
			push_error("ProjectileManager: Projectile type of UNKNOWN")
			return
		
		# Fill projectile's inactive pool
		if not inactive_pool.has(type):
			inactive_pool[type] = []
		for i in range(projectile_data.pool_size):
			var projectile: SGFixedNode2D = projectile_data.scene.instantiate()
			
			projectile.init(projectile_data)
			projectile.deactivate()
			
			add_child(projectile)
			inactive_pool[type].push_back(projectile)

func handle_requests(requests: Array[ProjectileRequest]) -> void:
	for req in requests:
		var projectile: SGFixedNode2D
	
		# Will point to the arrays for this projectile
		var inactive_pool: Array
		var active_pool: Array
		
		var projectile_data: ProjectileData = RegistryManager.get_projectile_data(req.type)
		if not projectile_data:
			push_warning("ProjectileManager: Projectile type '%s' not recognized" % req.type)
			continue
		
		# Determine which arrays to take from and put into
		var requested_base: ProjectileData.Base = projectile_data.base
		if requested_base == ProjectileData.Base.SOLID:
			inactive_pool = _solid_inactive[req.type]
			active_pool = _solid_active
		elif requested_base == ProjectileData.Base.SENSOR:
			inactive_pool = _sensor_inactive[req.type]
			active_pool = _sensor_active
		else:
			push_error("ProjectileManager: Projectile type of UNKNOWN")
			return
			
		# Take inactive projectile or create a new one
		if !inactive_pool.is_empty():
			projectile = inactive_pool.pop_back()
			projectile.activate(req.source, req.fp_pos_x, req.fp_pos_y, req.dir)
		else:
			push_warning("ProjectileManager: No projectile type '%s' available, creating one. Active projectiles: %d" % [req.type, active_pool.size()])
			
			projectile = projectile_data.scene.instantiate()
			
			projectile.init(projectile_data)
			projectile.activate(req.source, req.fp_pos_x, req.fp_pos_y, req.dir)
			
			add_child(projectile)
			
		active_pool.append(projectile)

func handle_modifiers(modifiers: Array[ProjectileModifier]) -> void:
	for mod in modifiers:
		mod.apply(_solid_active)
		mod.apply(_sensor_active)
		
		mod.check_applied()

func _process_pool(inactive_pool: Dictionary[StringName, Array], active_pool: Array) -> void:
	for i in range(active_pool.size() -1, -1, -1):
		var projectile: SGFixedNode2D = active_pool[i]
		
		projectile.advance_frame()
		if projectile.is_deactivated:
			active_pool.remove_at(i)
			inactive_pool[projectile.type].push_back(projectile)
