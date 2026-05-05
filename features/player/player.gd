extends SGCharacterBody2D

class_name Player

@export var collision_shape: SGCollisionShape2D
@export var loadout: Array[ProjectileData]

# Default stats
const DEFAULT_BASE_SPEED: int = 10

# Base stats
@export var base_speed: int = DEFAULT_BASE_SPEED:
	set(value):
		base_speed = value
		_compute_speed()

# Stat modifiers
@export var speed_mult: int = 1:
	set(value):
		speed_mult = value
		_compute_speed()

# Stats
var _speed: int = base_speed:
	set(value):
		_speed = value
		_fixed_speed = SGFixed.from_int(value)

# Equip
var equipped: ProjectileData

# Dimensions
var _fixed_radius: int:
	get:
		return collision_shape.shape.radius

# Fixed-point converted properties
var _fixed_speed: int = SGFixed.from_int(_speed)

# Input history
var _prev_input_mask: int = 0

var _projectile_request: ProjectileRequest = null

func _ready() -> void:
	equipped = loadout[0]

func _compute_speed() -> void:
	_speed = base_speed * speed_mult

func advance_frame(input_mask: int) -> void:
	var just_pressed_mask: int = input_mask & ~_prev_input_mask
	var just_released_mask: int = ~input_mask & _prev_input_mask
	
	# Equip
	if just_pressed_mask & InputConstants.Bit.EQUIP_1:
		equipped = loadout[0]
	elif just_pressed_mask & InputConstants.Bit.EQUIP_2:
		equipped = loadout[1]
	
	# Shooting
	# TODO: recovery frames
	if just_pressed_mask & InputConstants.Bit.SHOOT_UP:
		_projectile_request = ProjectileRequest.new(self, equipped, fixed_position_x, fixed_position_y - _fixed_radius, 0, -1)
	elif just_pressed_mask & InputConstants.Bit.SHOOT_DOWN:
		_projectile_request = ProjectileRequest.new(self, equipped, fixed_position_x, fixed_position_y + _fixed_radius, 0, 1)
	elif just_pressed_mask & InputConstants.Bit.SHOOT_LEFT:
		_projectile_request = ProjectileRequest.new(self, equipped, fixed_position_x - _fixed_radius, fixed_position_y, -1, 0)
	elif just_pressed_mask & InputConstants.Bit.SHOOT_RIGHT:
		_projectile_request = ProjectileRequest.new(self, equipped, fixed_position_x + _fixed_radius, fixed_position_y, 1, 0)
	
	# Sprint
	if just_pressed_mask & InputConstants.Bit.SPRINT: speed_mult += 1
	elif just_released_mask & InputConstants.Bit.SPRINT: speed_mult -= 1
	
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
	_prev_input_mask = input_mask
