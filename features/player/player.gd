extends SGCharacterBody2D

class_name Player

@export var collision_shape: SGCollisionShape2D
@export var basic_attack_scene: PackedScene
@export var skill_scenes: Array[PackedScene]

# Stats
@export var base_speed: int = 10

# Stat modifiers
@export var speed_mult: int = 1:
	set(value):
		speed_mult = value
		_speed = base_speed * speed_mult

# Computed stats
var _speed: int = 10:
	set(value):
		_speed = value
		_fixed_speed = SGFixed.from_int(value)

# Equipment
var basic_attack: Skill
var skills: Array[Skill] = []

# Tickers
var recovery_ticks: int = 0
var shoot_cd_ticks: int = 0

# Fixed-point converted properties
var _fixed_speed: int = SGFixed.from_int(_speed)
var _fixed_radius: int:
	get:
		return collision_shape.shape.radius

# Input masks
var _just_pressed_mask: int = 0
var _just_released_mask: int = 0
var _prev_input_mask: int = 0

var _projectile_request: ProjectileRequest = null

func init() -> void:
	# Initialize attack
	if basic_attack_scene != null:
		basic_attack = basic_attack_scene.instantiate()
		
		basic_attack.key_bit = InputConstants.BitGroup.ATK
		
		add_child(basic_attack)
	
	# Initialize skills
	for i in range(skill_scenes.size()):
		var skill: Skill = skill_scenes[i].instantiate()
		
		skill.key_bit = InputConstants.BitList.SKILLS[i]
		
		add_child(skill)
		skills.append(skill)

func advance_frame(input_mask: int) -> void:
	_just_pressed_mask = input_mask & ~_prev_input_mask
	_just_released_mask = ~input_mask & _prev_input_mask
	_prev_input_mask = input_mask
	
	if recovery_ticks > 0:
		recovery_ticks -= 1
		return
	
	# Determine aim direction, use attack direction or movement direciton otherwise
	var aim_dir_x: int = 0
	var aim_dir_y: int = 0
	if input_mask & InputConstants.Bit.ATK_UP: aim_dir_y = -1
	elif input_mask & InputConstants.Bit.ATK_DOWN: aim_dir_y = 1
	elif input_mask & InputConstants.Bit.ATK_LEFT: aim_dir_x = -1
	elif input_mask & InputConstants.Bit.ATK_RIGHT: aim_dir_x = 1
	elif input_mask & InputConstants.Bit.MOVE_UP: aim_dir_y = -1
	elif input_mask & InputConstants.Bit.MOVE_DOWN: aim_dir_y = 1
	elif input_mask & InputConstants.Bit.MOVE_LEFT: aim_dir_x = -1
	elif input_mask & InputConstants.Bit.MOVE_RIGHT: aim_dir_x = 1
	else: return # TODO: replace movement direction with sprite direction
	
	# Skills
	for i in range(skills.size()):
		skills[i].advance_frame(self, input_mask, _just_pressed_mask, _just_released_mask, aim_dir_x, aim_dir_y)
	
	# Basic attack
	if basic_attack != null:
		basic_attack.advance_frame(self, input_mask, _just_pressed_mask, _just_released_mask, aim_dir_x, aim_dir_y)
	
	# Movement
	var x_input: int = 0
	var y_input: int = 0
	
	if input_mask & InputConstants.Bit.MOVE_LEFT: x_input = -1
	elif input_mask & InputConstants.Bit.MOVE_RIGHT: x_input = 1
	
	if input_mask & InputConstants.Bit.MOVE_UP: y_input = -1
	elif input_mask & InputConstants.Bit.MOVE_DOWN: y_input = 1
	
	velocity.x = x_input * _fixed_speed
	velocity.y = y_input * _fixed_speed
	
	move_and_slide()
