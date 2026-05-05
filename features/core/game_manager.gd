extends Node

@export var inputManager: InputManager
@export var player: Player
@export var projectileManager: ProjectileManager

func _ready() -> void:
	# Determine data for pool initialization
	var data_map: Dictionary[PackedScene, ProjectileManager.PoolInitData] = {}
	for projectile_data: ProjectileData in player.loadout:
		if data_map.has(projectile_data.scene):
			data_map[projectile_data.scene].size += projectile_data.pool_size
		else:
			var pool_data: ProjectileManager.PoolInitData = ProjectileManager.PoolInitData.new()
			
			pool_data.type = projectile_data.type
			pool_data.size = projectile_data.pool_size
			
			data_map[projectile_data.scene] = pool_data
	
	# Hand off data to projectile manager to initialize pools
	projectileManager.init_pools(data_map)

func _physics_process(_delta: float) -> void:
	var input_mask: int = inputManager.get_input_mask()
	player.advance_frame(input_mask)
	
	if(player._projectile_request):
		projectileManager.spawn_projectile(player._projectile_request)
		player._projectile_request = null
	
	projectileManager.advance_frame()
