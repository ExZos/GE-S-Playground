extends SGCharacterBody2D

class_name Player

@export var collision_shape: SGCollisionShape2D
@export var skill_manager: SkillManager

@export var player_stats: PlayerStats
@export var basic_attack_type: SkillData.Type
@export var skill_types: Array[SkillData.Type]

# Stats
var fp_base_speed: int:
	set(value):
		fp_base_speed = value
		_compute_speed()

# Stat modifiers
var fp_speed_mult: int = SGFixed.ONE:
	set(value):
		fp_speed_mult = value
		_compute_speed()

# Computed stats
var _fp_speed: int

# Tickers
var fp_recovery_ticks: int = 0

# Dimensions
var _fp_half_width: int:
	get:
		return collision_shape.shape.radius

# Input masks
var _just_pressed_mask: int = 0
var _just_released_mask: int = 0
var _prev_input_mask: int = 0

# 
var _projectile_requests: Array[ProjectileRequest] = []
var _projectile_modifiers: Array[ProjectileModifier] = []
var _vfx_events: Array[VFXEvent] = []

func init() -> void:
	fp_base_speed = SGFixed.from_int(player_stats.base_speed)
	fp_speed_mult = fp_speed_mult
	
	skill_manager.init(self, basic_attack_type, skill_types)

func advance_frame(input_mask: int) -> void:
	_just_pressed_mask = input_mask & ~_prev_input_mask
	_just_released_mask = ~input_mask & _prev_input_mask
	_prev_input_mask = input_mask
	
	# Process tickers
	skill_manager.process_tickers()
	
	if fp_recovery_ticks > 0:
		fp_recovery_ticks -= SGFixed.ONE
		return
	
	# Skill activations
	skill_manager.advance_frame(input_mask, _just_pressed_mask, _just_released_mask)
	
	# Movement
	var x_input: int = 0
	var y_input: int = 0
	
	if input_mask & InputConstants.Bit.MOVE_LEFT: x_input = -1
	elif input_mask & InputConstants.Bit.MOVE_RIGHT: x_input = 1
	
	if input_mask & InputConstants.Bit.MOVE_UP: y_input = -1
	elif input_mask & InputConstants.Bit.MOVE_DOWN: y_input = 1
	
	velocity.x = x_input * _fp_speed
	velocity.y = y_input * _fp_speed
	
	move_and_slide()

func _compute_speed() -> void:
	_fp_speed = SGFixed.mul(fp_base_speed, fp_speed_mult)
