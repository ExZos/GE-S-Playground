extends Node

class_name ProjectileManager

class PoolInitData:
	var type: ProjectileData.ProjectileType
	var size: int

# Solid projectile pools
var _solid_inactive: Dictionary[PackedScene, Array] = {}
var _solid_active: Array[SolidProjectile] = []

# Sensor projectile pools
var _sensor_inactive: Dictionary[PackedScene, Array] = {}
var _sensor_active: Array[SensorProjectile]

func advance_frame() -> void:
	_process_pool(_solid_inactive, _solid_active)
	_process_pool(_sensor_inactive, _sensor_active)

func init_pools(data_map: Dictionary[PackedScene, PoolInitData]) -> void:
	for scene: PackedScene in data_map:
		var pool_data: PoolInitData = data_map[scene]
		var inactive_pool: Dictionary[PackedScene, Array]
		
		# Determine type of inactive pool to fill
		if pool_data.type == ProjectileData.ProjectileType.SOLID:
			inactive_pool = _solid_inactive
		elif pool_data.type == ProjectileData.ProjectileType.SENSOR:
			inactive_pool = _sensor_inactive
		else:
			push_error("ProjectileManager: Projectile type of UNKNOWN")
			return
		
		# Fill projectile's inactive pool
		inactive_pool[scene] = []
		for i in range(pool_data.size):
			var projectile: Node2D = scene.instantiate()
			
			projectile.source_scene = scene
			projectile.deactivate()
			
			add_child(projectile)
			
			inactive_pool[scene].push_back(projectile)

func spawn_projectile(req: ProjectileRequest) -> void:
	var projectile: Node2D
	
	# Will point to the arrays for this projectile
	var inactive_pool: Array
	var active_pool: Array
	
	# Determine which arrays to take from and put into
	var requested_scene: PackedScene = req.data.scene
	var requested_type: ProjectileData.ProjectileType = req.data.type
	if requested_type == ProjectileData.ProjectileType.SOLID:
		inactive_pool = _solid_inactive[requested_scene]
		active_pool = _solid_active
	elif requested_type == ProjectileData.ProjectileType.SENSOR:
		inactive_pool = _sensor_inactive[requested_scene]
		active_pool = _sensor_active
	else:
		push_error("ProjectileManager: Projectile type of UNKNOWN")
		return
		
	# Take inactive projectile or create a new one
	if !inactive_pool.is_empty():
		projectile = inactive_pool.pop_back()
		projectile.activate(req.source, req.fixed_pos_x, req.fixed_pos_y, req.dir_x, req.dir_y)
	else:
		print("No projectiles available, creating one. Active projectiles: ", active_pool.size())
		
		projectile = requested_scene.instantiate()
		
		projectile.source_scene = requested_scene
		projectile.activate(req.source, req.fixed_pos_x, req.fixed_pos_y, req.dir_x, req.dir_y)
		
		add_child(projectile)
		
	active_pool.append(projectile)

func _process_pool(inactive_pool: Dictionary[PackedScene, Array], active_pool: Array) -> void:
	for i in range(active_pool.size() -1, -1, -1):
		var projectile: Node2D = active_pool[i]
		
		projectile.advance_frame()
		if projectile.is_deactivated:
			active_pool.remove_at(i)
			inactive_pool[projectile.source_scene].push_back(projectile)
