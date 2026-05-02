extends SGCharacterBody2D

class_name Player

@onready var projectileManager: ProjectileManager = get_node("../ProjectileManager")
@onready var collisionShape: SGCollisionShape2D = get_node("./SGCollisionShape2D")

# Default stats
const DEFAULT_BASE_SPEED: int = 10

# Base stats
@export var base_speed: int = DEFAULT_BASE_SPEED:
	set(new_base_speed):
		base_speed = new_base_speed
		_compute_speed()

# Stat modifiers
@export var speed_mult: int = 1:
	set(new_speed_mult):
		speed_mult = new_speed_mult
		_compute_speed()

# Stats
var _speed: int = base_speed:
	set(new_speed):
		_speed = new_speed
		_sg_speed = SGFixed.from_int(new_speed)

# Dimensions
var _fixed_radius: int:
	get:
		return collisionShape.shape.radius

# SG converted properties
var _sg_speed: int = SGFixed.from_int(_speed)

# Input history
var _prev_input_mask: int = 0

func _compute_speed() -> void:
	_speed = base_speed * speed_mult

func execute_input(input_mask: int) -> void:
	var just_pressed_mask: int = input_mask & ~_prev_input_mask
	var just_released_mask: int = ~input_mask & _prev_input_mask
	
	# Shooting
	# TODO: recovery frames
	if just_pressed_mask & InputConstants.Bit.SHOOT_UP:
		projectileManager.spawn_projectile(self, fixed_position_x, fixed_position_y - _fixed_radius, 0, -1)
	elif just_pressed_mask & InputConstants.Bit.SHOOT_DOWN:
		projectileManager.spawn_projectile(self, fixed_position_x, fixed_position_y + _fixed_radius, 0, 1)
	elif just_pressed_mask & InputConstants.Bit.SHOOT_LEFT:
		projectileManager.spawn_projectile(self, fixed_position_x - _fixed_radius, fixed_position_y, -1, 0)
	elif just_pressed_mask & InputConstants.Bit.SHOOT_RIGHT:
		projectileManager.spawn_projectile(self, fixed_position_x + _fixed_radius, fixed_position_y, 1, 0)
	
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
	
	velocity.x = x_input * _sg_speed
	velocity.y = y_input * _sg_speed
	move_and_slide()
	
	_prev_input_mask = input_mask
