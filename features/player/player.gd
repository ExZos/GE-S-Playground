extends SGCharacterBody2D

class_name Player

@export var collision_shape: SGCollisionShape2D
@export var skill_manager: SkillManager

@export var player_stats: PlayerStats
@export var basic_attack_type: SkillData.Type
@export var skill_types: Array[SkillData.Type]

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

# Dimensions
var _fp_half_width: int:
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
var player_modifiers_is_dirty: bool = false

# 
var projectile_requests: Array[ProjectileRequest] = []
var projectile_modifiers: Array[ProjectileModifier] = []
var vfx_events: Array[VFXEvent] = []

func init() -> void:
	fp_base_speed = SGFixed.from_int(player_stats.base_speed)
	_compute_speed()
	
	skill_manager.init(self, basic_attack_type, skill_types)

func advance_frame(input_mask: int) -> void:
	_just_pressed_mask = input_mask & ~_prev_input_mask
	_just_released_mask = ~input_mask & _prev_input_mask
	_prev_input_mask = input_mask
	
	# Process tickers
	skill_manager.process_tickers()
	
	for i in range(_player_modifiers.size() - 1, -1, -1):
		if not _player_modifiers[i].tick_and_check():
			remove_modifier_at(i)
	
	if fp_recovery_ticks > 0:
		fp_recovery_ticks -= SGFixed.ONE
		return
	
	# Handle movement inputs
	if input_mask & InputConstants.Bit.MOVE_LEFT: mov_dir.x = -1
	elif input_mask & InputConstants.Bit.MOVE_RIGHT: mov_dir.x = 1
	else: mov_dir.x = 0
	
	if input_mask & InputConstants.Bit.MOVE_UP: mov_dir.y = -1
	elif input_mask & InputConstants.Bit.MOVE_DOWN: mov_dir.y = 1
	else: mov_dir.y = 0
	
	# Skill activations
	skill_manager.advance_frame(input_mask, _just_pressed_mask, _just_released_mask, mov_dir)
	
	# Apply modifiers
	if player_modifiers_is_dirty:
		# Reset stats
		fp_speed_add = 0
		fp_speed_mult_sum = SGFixed.ONE
		fp_speed_mult_prod = SGFixed.ONE
		forced_mov_dir = Vector2i.ZERO
		
		for mod in _player_modifiers:
			mod.apply()
		
		_compute_speed()
		player_modifiers_is_dirty = false
	
	# Movement
	var effective_mov_dir: Vector2i = mov_dir
	if forced_mov_dir != Vector2i.ZERO: effective_mov_dir = forced_mov_dir
	
	velocity.x = effective_mov_dir.x * _fp_speed
	velocity.y = effective_mov_dir.y * _fp_speed
	
	move_and_slide()

# --- Skill manager getters ---
func get_basic_attack() -> Skill:
	return skill_manager._basic_attack

func get_skills() -> Array[Skill]:
	return skill_manager._skills

# --- Player modifier wrappers ---
func add_modifier(modifier: PlayerModifier) -> void:
	_player_modifiers.append(modifier)
	player_modifiers_is_dirty = true

func remove_modifier_at(index: int) -> void:
	_player_modifiers.remove_at(index)
	player_modifiers_is_dirty = true

func remove_modifier(modifier: PlayerModifier) -> void:
	_player_modifiers.erase(modifier)
	player_modifiers_is_dirty = true

# --- Private functions ---
func _compute_speed() -> void:
	_fp_speed = SGFixed.mul(fp_base_speed + fp_speed_add, SGFixed.mul((fp_speed_mult_sum), fp_speed_mult_prod))
	print(SGFixed.to_int(_fp_speed))
