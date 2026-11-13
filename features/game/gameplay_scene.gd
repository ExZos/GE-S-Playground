extends Node

class_name GameplayScene

@onready var arena: Arena = $Arena
@onready var player_input: PlayerInput = $PlayerInput
@onready var player: Player = $Player
@onready var projectile_manager: ProjectileManager = $ProjectileManager
@onready var enemy_manager: EnemyManager = $EnemyManager
@onready var encounter_manager: EncounterManager = $EncounterManager

# TODO: in-game selection before loading
@export var player_data: PlayerData
@export var encounter_data: EncounterData

const PROJECTILE_MODIFIERS_POOL_SIZE: int = 10

var _projectile_modifiers: DenseFixedArray
var _rng: RandomNumberGenerator

var _prev_input_mask: int

var is_paused: bool

func _enter_tree() -> void:
	GameplayEventBus.current = GameplayEventBus.new()

func _ready() -> void:
	GameplayEventBus.current.register_gameplay_scene(self)
	RegistryManager.init()
	
	_projectile_modifiers = DenseFixedArray.new(PROJECTILE_MODIFIERS_POOL_SIZE, TYPE_OBJECT, ProjectileModifier)
	_rng = RandomNumberGenerator.new() # TODO: exported seed param
	
	_prev_input_mask = 0
	is_paused = false
	
	arena.init()
	($VFXLayer).init() # Execution is not managed
	
	player.init(player_data)
	encounter_manager.init(encounter_data)
	
	# TODO: consider having projectile pool data in character data
	# Used to store data for pool initialization
	var projectile_types: Dictionary[StringName, int] = {}
	
	# TODO: refactor, make skills offer projectile pool init data 
	_scan_character_for_projectiles(projectile_types, player)
	
	for enemy: Enemy in enemy_manager.get_all_enemies():
		_scan_character_for_projectiles(projectile_types, enemy)
	
	# Hand off data to projectile manager to initialize pools
	# TODO: consider moving before player init (scan resources instead)
	projectile_manager.init(projectile_types)
	
	# More nodes whose execution are not managed
	($UILayer).init(self)

func _exit_tree() -> void:
	GameplayEventBus.current = null

func _physics_process(_delta: float) -> void:
	var input_mask: int = player_input.get_input_mask()
	var just_pressed_mask: int = input_mask & ~_prev_input_mask
	
	# TODO: have a separate node handle this?
	if just_pressed_mask & InputConstants.Bit.PAUSE:
		is_paused = !is_paused  
	
	if is_paused:
		_prev_input_mask = input_mask
		return
	
	enemy_manager.read_input_masks()
	
	if player.is_active:
		player.advance_frame(input_mask, _prev_input_mask)
	
	# TODO: have a separate node handle this?
	if just_pressed_mask & InputConstants.Bit.RESPAWN:
		if not player.is_active:
			# TODO: dynamically select spawn position based on zone enemy density
			player.activate(0, 0)
	if just_pressed_mask & InputConstants.Bit.NEXT_WAVE:
		encounter_manager.spawn_wave(player.fixed_position_x, player.fixed_position_y)
	
	enemy_manager.advance_frame()
	
	if player.projectile_requests.count > 0:
		projectile_manager.handle_requests(player.projectile_requests)
		player.clear_projectile_requests()
	
	if enemy_manager.projectile_requests.count > 0:
		projectile_manager.handle_requests(enemy_manager.projectile_requests)
		enemy_manager.clear_projectile_requests()
	
	if _projectile_modifiers.count > 0:
		projectile_manager.handle_modifiers(_projectile_modifiers)
		_projectile_modifiers.clear_data()
	
	projectile_manager.advance_frame()
	
	_prev_input_mask = input_mask

func get_player_position() -> SGFixedVector2:
	if not player.is_active:
		return SGFixed.vector2(0, 0)
	
	return player.fixed_position

func add_projectile_modifier(modifier: ProjectileModifier) -> void:
	if _projectile_modifiers.add_item(modifier) == -1:
		_projectile_modifiers.forced_expand("%s -> Projectile modifiers" % name, 1)
		
		_projectile_modifiers.add_item(modifier)

func get_randi_range(from: int, to: int) -> int:
	return _rng.randi_range(from, to)

func _scan_character_for_projectiles(projectile_types: Dictionary[StringName, int], character: Character) -> void:
	var attack: Skill = character.get_attack()
	if attack and attack is ShootSkill:
		if projectile_types.has(attack.projectile_type):
			projectile_types[attack.projectile_type] += 1
		else:
			projectile_types[attack.projectile_type] = 1
	
	var skills: Array[Skill] = character.get_skills()
	for s: Skill in skills:
		if s is ShootSkill:
			if projectile_types.has(s.projectile_type):
				projectile_types[s.projectile_type] += 1
			else:
				projectile_types[s.projectile_type] = 1
