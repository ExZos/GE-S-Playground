extends Node

# TODO: make inactive pool arrays fixed-size
# TODO: use FixedArray
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
	var largest_pool: Dictionary[int, int] = {
		ProjectileData.Base.SOLID: 0,
		ProjectileData.Base.SENSOR: 0
	}
	
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
			push_error("ProjectileManager: Projectile base '%d' not recognized" %  projectile_base)
			return
		
		# Keep track of largest pool per base
		if largest_pool[projectile_base] < projectile_data.pool_size: 
			largest_pool[projectile_base] = projectile_data.pool_size
		
		# Fill projectile's inactive pool
		if not inactive_pool.has(type):
			inactive_pool[type] = []
		for i in range(projectile_data.pool_size):
			var projectile: SGFixedNode2D = projectile_data.scene.instantiate()
			
			projectile.init(projectile_data)
			projectile.deactivate()
			projectile.reset()
			
			add_child(projectile)
			inactive_pool[type].append(projectile)
	
	_solid_active.resize(largest_pool[ProjectileData.Base.SOLID])
	_sensor_active.resize(largest_pool[ProjectileData.Base.SENSOR])

func handle_requests(requests: DenseFixedArray) -> void:
	var next_available_index: int = 0
	
	for i in range(requests.count):
		var req: ProjectileRequest = requests.data[i]
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
			push_error("ProjectileManager: Projectile base '%s' not recognized" % requested_base)
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
		
		# Get next available index
		for j in range(next_available_index, active_pool.size()):
			if not active_pool[j]:
				next_available_index = j
				#print(j)
				break
		
		if active_pool[next_available_index]:
			push_warning("ProjectileManager: No active pool space for projectile base '%s', creating one. Total '%s' active pool space: %d" % [requested_base, requested_base, active_pool.size()])
			active_pool.resize(active_pool.size() + 1)
			active_pool[active_pool.size() - 1] = projectile
		else:
			active_pool[next_available_index] = projectile

func handle_modifiers(modifiers: Array[ProjectileModifier], count: int) -> void:
	for i in range(count):
		var mod: ProjectileModifier = modifiers[i]
		
		mod.apply(_solid_active)
		mod.apply(_sensor_active)
		
		mod.check_applied()

func _process_pool(inactive_pool: Dictionary[StringName, Array], active_pool: Array) -> void:
	for i in range(active_pool.size() -1, -1, -1):
		var projectile: SGFixedNode2D = active_pool[i]
		if not projectile:
			continue
		
		projectile.advance_frame()
		if projectile.is_deactivated:
			projectile.reset()
			active_pool[i] = null
			inactive_pool[projectile.type].append(projectile)
