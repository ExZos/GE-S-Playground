extends SGCharacterBody2D

# TODO: refactor with skill manager and registry
class_name Player

@export var collision_shape: SGCollisionShape2D
@export var player_stats: PlayerStats
@export var basic_attack_scene: PackedScene
@export var skill_scenes: Array[PackedScene] # TODO: swap for resources

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

# Loadout
var _basic_attack: Skill
var _skills: Array[Skill] = []

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
	
	# Initialize attack
	if basic_attack_scene != null:
		_basic_attack = basic_attack_scene.instantiate()
		
		_basic_attack.source = self
		_basic_attack.key_bit = InputConstants.BitGroup.ATK
		
		add_child(_basic_attack)
	
	# Initialize skills
	for i in range(skill_scenes.size()):
		var skill: Skill = skill_scenes[i].instantiate()
		
		skill.source = self
		skill.key_bit = InputConstants.BitList.SKILLS[i]
		
		add_child(skill)
		_skills.append(skill)

func advance_frame(input_mask: int) -> void:
	_just_pressed_mask = input_mask & ~_prev_input_mask
	_just_released_mask = ~input_mask & _prev_input_mask
	_prev_input_mask = input_mask
	
	# Process tickers
	_basic_attack.process_tickers()
	
	for skill: Skill in _skills:
		skill.process_tickers()
	
	if fp_recovery_ticks > 0:
		fp_recovery_ticks -= SGFixed.ONE
		return
	
	# Determine skill direction using held attack direction or movement direction otherwise
	var skill_dir: Vector2i = Vector2i.ZERO
	if input_mask & InputConstants.Bit.ATK_UP: skill_dir = Vector2i.UP
	elif input_mask & InputConstants.Bit.ATK_DOWN: skill_dir = Vector2i.DOWN
	elif input_mask & InputConstants.Bit.ATK_LEFT: skill_dir = Vector2i.LEFT
	elif input_mask & InputConstants.Bit.ATK_RIGHT: skill_dir = Vector2i.RIGHT
	elif input_mask & InputConstants.Bit.MOVE_UP: skill_dir = Vector2i.UP
	elif input_mask & InputConstants.Bit.MOVE_DOWN: skill_dir = Vector2i.DOWN
	elif input_mask & InputConstants.Bit.MOVE_LEFT: skill_dir = Vector2i.LEFT
	elif input_mask & InputConstants.Bit.MOVE_RIGHT: skill_dir = Vector2i.RIGHT
	
	# Determine attack direction
	var atk_dir: Vector2i = Vector2i.ZERO
	if _just_pressed_mask & InputConstants.Bit.ATK_UP: atk_dir = Vector2i.UP
	elif _just_pressed_mask & InputConstants.Bit.ATK_DOWN: atk_dir = Vector2i.DOWN
	elif _just_pressed_mask & InputConstants.Bit.ATK_LEFT: atk_dir = Vector2i.LEFT
	elif _just_pressed_mask & InputConstants.Bit.ATK_RIGHT: atk_dir = Vector2i.RIGHT
	
	# Skills
	for skill: Skill in _skills:
		skill.advance_frame(input_mask, _just_pressed_mask, _just_released_mask, skill_dir)
	
	# Basic attack
	if _basic_attack != null:
		_basic_attack.advance_frame(input_mask, _just_pressed_mask, _just_released_mask, atk_dir)
	
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
