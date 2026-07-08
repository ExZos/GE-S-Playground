@tool
extends SGCharacterBody2D

class_name Player

@export var collision_shape: SGCollisionShape2D
@export var skill_manager: SkillManager

@export var player_stats: PlayerStats
@export var attack_type: StringName
@export var skill_types: Array[StringName]

const PROJECTILE_REQUESTS_POOL_SIZE: int = 5
const PLAYER_MODIFIERS_POOL_SIZE: int = 5

# Stats
var fp_base_speed: int

# Stat modifiers
var fp_speed_add: int = 0
var fp_speed_mult_sum: int = SGFixed.ONE
var fp_speed_mult_prod: int = SGFixed.ONE

# Computed stats
var _fp_speed: int

# Tickers
var fp_recovery_ticks: int = 0

# Restriction states
var is_recovering: bool = false
var restrict_attack: bool = false
var restrict_skills: bool = false

# Dimensions
var fp_half_width: int:
	get:
		return collision_shape.shape.radius

# Movement
var mov_dir: Vector2i = Vector2i.ZERO
var forced_mov_dir: Vector2i = Vector2i.ZERO

# Input masks
var _just_pressed_mask: int = 0
var _just_released_mask: int = 0
var _prev_input_mask: int = 0

# 
var _player_modifiers: Array[PlayerModifier] = []
var _player_modifiers_count: int = 0
var _player_modifiers_is_dirty: bool = false

# 
var projectile_requests: DenseFixedArray

func _validate_property(property: Dictionary) -> void:
	var skill_type_hint: String = ",".join(RegistryKeys.Skills.LIST)
	
	if property.name == "attack_type":
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = skill_type_hint
		
	if property.name == "skill_types":
		property.hint = PROPERTY_HINT_ARRAY_TYPE
		property.hint_string = "%d/%d:%s" % [TYPE_STRING_NAME, PROPERTY_HINT_ENUM, skill_type_hint]

func init() -> void:
	_player_modifiers.resize(PLAYER_MODIFIERS_POOL_SIZE)
	projectile_requests = DenseFixedArray.new(PROJECTILE_REQUESTS_POOL_SIZE, ProjectileRequest)
	
	fp_base_speed = SGFixed.from_int(player_stats.base_speed)
	_compute_speed()
	
	skill_manager.init(self, attack_type, skill_types)

func advance_frame(input_mask: int) -> void:
	_just_pressed_mask = input_mask & ~_prev_input_mask
	_just_released_mask = ~input_mask & _prev_input_mask
	_prev_input_mask = input_mask
	
	# Process tickers
	skill_manager.process_tickers()
	
	for i in range(_player_modifiers.size()):
		# Check if modifier's ticker expired
		if _player_modifiers[i] and not _player_modifiers[i].tick_and_check():
			remove_modifier_at(i)
	
	is_recovering = fp_recovery_ticks > 0
	if is_recovering:
		fp_recovery_ticks -= SGFixed.ONE
	
	# Handle movement inputs
	if input_mask & InputConstants.Bit.MOVE_LEFT: mov_dir.x = -1
	elif input_mask & InputConstants.Bit.MOVE_RIGHT: mov_dir.x = 1
	else: mov_dir.x = 0
	
	if input_mask & InputConstants.Bit.MOVE_UP: mov_dir.y = -1
	elif input_mask & InputConstants.Bit.MOVE_DOWN: mov_dir.y = 1
	else: mov_dir.y = 0
	
	# Attack and skill activations (since attack is also a skill)
	skill_manager.advance_frame(input_mask, _just_pressed_mask, _just_released_mask, mov_dir)
	
	# Apply modifiers
	if _player_modifiers_is_dirty:
		# Reset stats
		fp_speed_add = 0
		fp_speed_mult_sum = SGFixed.ONE
		fp_speed_mult_prod = SGFixed.ONE
		forced_mov_dir = Vector2i.ZERO
		
		# Reset restrictions
		restrict_attack = false
		restrict_skills = false
		
		for mod: PlayerModifier in _player_modifiers:
			if mod:
				mod.apply()
		
		_compute_speed()
		_player_modifiers_is_dirty = false
	
	# Movement
	if is_recovering:
		return
		
	var effective_mov_dir: Vector2i = mov_dir
	if forced_mov_dir != Vector2i.ZERO: effective_mov_dir = forced_mov_dir
	
	velocity.x = effective_mov_dir.x * _fp_speed
	velocity.y = effective_mov_dir.y * _fp_speed
	
	move_and_slide()

# --- Restriction utilities ---
func check_restrict_attack() -> bool:
	return restrict_attack or is_recovering

func check_restrict_skills() -> bool:
	return restrict_skills or is_recovering

# --- Skill manager getters ---
func get_attack() -> Skill:
	return skill_manager._attack

func get_skills() -> Array[Skill]:
	return skill_manager._skills

# --- Player modifier wrappers ---
func add_modifier(modifier: PlayerModifier) -> void:
	var next_available_index: int = -1
	
	if _player_modifiers_count < _player_modifiers.size():
		for i in range(_player_modifiers.size()):
			if not _player_modifiers[i]:
				next_available_index = i
				break
	else:
		push_warning("Player: No player modifier available, creating one. Total player modifiers: %d" % _player_modifiers.size())
		next_available_index = _player_modifiers.size()
		_player_modifiers.resize(_player_modifiers.size() + 1)
	
	_player_modifiers[next_available_index] = modifier
	_player_modifiers_count += 1
	
	_player_modifiers_is_dirty = true

func remove_modifier_at(index: int) -> void:
	_player_modifiers[index] = null
	_player_modifiers_count -= 1
	
	_player_modifiers_is_dirty = true

func remove_modifier(modifier: PlayerModifier) -> void:
	var index: int = _player_modifiers.find(modifier)
	_player_modifiers[index] = null
	_player_modifiers_count -= 1
	
	_player_modifiers_is_dirty = true

# --- Projectile request wrappers ---
func add_projectile_request(request: ProjectileRequest) -> void:
	if not projectile_requests.add_item(request):
		push_warning("Player: No projectile request available, creating one. Total projectile requests: %d" % projectile_requests.size())
		projectile_requests.data.resize(projectile_requests.max_size + 1)
		projectile_requests.max_size += 1
		
		projectile_requests.add_item(request)

func clear_projectile_requests() -> void:
	projectile_requests.clear_data()

# --- Private functions ---
func _compute_speed() -> void:
	_fp_speed = SGFixed.mul(fp_base_speed + fp_speed_add, SGFixed.mul((fp_speed_mult_sum), fp_speed_mult_prod))
