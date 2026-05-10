extends Node

@export var inputManager: InputManager
@export var player: Player
@export var projectileManager: ProjectileManager

func _ready() -> void:
	player.init()
	
	# Used to store data for pool initialization
	var data_map: Dictionary[PackedScene, ProjectileManager.PoolInitData] = {}
	
	# Get data from equipped projectile for pool initialization
	var basic_attack = player._basic_attack
	if basic_attack and basic_attack is ShootSkill and basic_attack.projectile:
		_map_projectile_init_data(data_map, basic_attack.projectile)
	
	# Get data from skills for pool initialization
	for skill: Skill in player._skills:
		if skill is ShootSkill and skill.projectile:
			_map_projectile_init_data(data_map, skill.projectile)
	
	# Hand off data to projectile manager to initialize pools
	projectileManager.init(data_map)

func _physics_process(_delta: float) -> void:
	var input_mask: int = inputManager.get_input_mask()
	player.advance_frame(input_mask)
	
	if(player._projectile_request):
		projectileManager.spawn_projectile(player._projectile_request)
		player._projectile_request = null
	
	projectileManager.advance_frame()

# Get the projectile's init-relevant data and add it to the map
func _map_projectile_init_data(data_map: Dictionary[PackedScene, ProjectileManager.PoolInitData], projectile_data: ProjectileData) -> void:
	if data_map.has(projectile_data.scene):
		data_map[projectile_data.scene].total_size += projectile_data.pool_size
	else:
		var pool_data: ProjectileManager.PoolInitData = ProjectileManager.PoolInitData.new()
		
		pool_data.data = projectile_data
		pool_data.total_size = projectile_data.pool_size
		
		data_map[projectile_data.scene] = pool_data
