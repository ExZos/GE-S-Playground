extends Node

class_name GameManager

@export var input_manager: InputManager
@export var player: Player
@export var projectile_manager: ProjectileManager

var projectile_modifiers: Array[ProjectileModifier] = []

func _ready() -> void:
	EventBus.register_game_manager(self)
	
	RegistryManager.init()
	
	player.init()
	
	# Used to store data for pool initialization
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
	
	if not player.projectile_requests.is_empty():
		projectile_manager.handle_requests(player.projectile_requests)
		player.projectile_requests.clear()
	
	if not projectile_modifiers.is_empty():
		projectile_manager.handle_modifiers(projectile_modifiers)
		projectile_modifiers.clear()
	
	projectile_manager.advance_frame()

func add_projectile_modifier(modifier: ProjectileModifier) -> void:
	projectile_modifiers.append(modifier)
