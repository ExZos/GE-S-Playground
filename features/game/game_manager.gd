extends Node

class_name GameManager

@export var input_manager: InputManager
@export var player: Player
@export var projectile_manager: ProjectileManager

const PROJECTILE_MODIFIERS_POOL_SIZE: int = 10

var _projectile_modifiers: DenseFixedArray

func _ready() -> void:
	EventBus.register_game_manager(self)
	RegistryManager.init()
	
	_projectile_modifiers = DenseFixedArray.new(PROJECTILE_MODIFIERS_POOL_SIZE, ProjectileModifier)
	
	player.init()
	
	# Used to store data for pool initialization
	# TODO: make fixed-size
	var projectile_types: Array[StringName] = []
	
	# TODO: refactor, make skills offer projectile pool init data 
	# Get data from equipped projectile for pool initialization
	var attack: Skill = player.get_attack()
	if attack and attack is ShootSkill:
		projectile_types.append(attack.projectile_type)
	
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
	
	if player.projectile_requests.count > 0:
		projectile_manager.handle_requests(player.projectile_requests)
		player.clear_projectile_requests()
	
	if _projectile_modifiers.count > 0:
		projectile_manager.handle_modifiers(_projectile_modifiers)
		_projectile_modifiers.clear_data()
	
	projectile_manager.advance_frame()

func add_projectile_modifier(modifier: ProjectileModifier) -> void:
	if not _projectile_modifiers.add_item(modifier):
		push_warning("GameManager: No projectile modifier available, creating one. Total projectile modifiers: %d" % _projectile_modifiers.max_size)
		_projectile_modifiers.data.resize(_projectile_modifiers.max_size + 1)
		_projectile_modifiers.max_size += 1
		
		_projectile_modifiers.add_item(modifier)
