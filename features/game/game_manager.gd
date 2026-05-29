extends Node

@export var input_manager: InputManager
@export var player: Player
@export var projectile_manager: ProjectileManager

func _ready() -> void:
	player.init()
	
	# Used to store data for pool initialization
	var projectile_types: Array[ProjectileData.Type] = []
	
	# TODO: refactor, make skills offer projectile pool init data 
	# Get data from equipped projectile for pool initialization
	var basic_attack: Skill = player.get_basic_attack()
	if basic_attack and basic_attack is ShootSkill:
		projectile_types.append(basic_attack.projectile_type)
	
	# Get data from skills for pool initialization
	var player_skills: Array[Skill] = player.get_skills()
	for skill: Skill in player_skills:
		if skill is ShootSkill:
			projectile_types.append(skill.projectile_type)
	
	# Hand off data to projectile manager to initialize pools
	projectile_manager.init(projectile_types)

func _physics_process(_delta: float) -> void:
	var input_mask: int = input_manager.get_input_mask()
	player.advance_frame(input_mask)
	
	if not player._projectile_requests.is_empty():
		projectile_manager.handle_requests(player._projectile_requests)
		player._projectile_requests.clear()
	
	if not player._projectile_modifiers.is_empty():
		projectile_manager.handle_modifiers(player._projectile_modifiers)
		player._projectile_modifiers.clear()
	
	projectile_manager.advance_frame()

# Get the projectile's init-relevant data and add it to the map
#func _map_projectile_init_data(data_map: Dictionary[ProjectileData.Type, ProjectileManager.PoolInitData], projectile_type: ProjectileData.Type) -> void:
	#var projectile_data: ProjectileData = projectile_registry.get_data()
	#
	#if data_map.has(projectile_type):
		#data_map[projectile_type].total_size += projectile_data.pool_size
	#else:
		#var pool_data: ProjectileManager.PoolInitData = ProjectileManager.PoolInitData.new()
		#
		#pool_data.data = projectile_data
		#pool_data.total_size = projectile_data.pool_size
		#
		#data_map[projectile_data.scene] = pool_data
