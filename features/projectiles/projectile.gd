extends SGCharacterBody2D

class_name Projectile

# Default stats
const DEFAULT_SPEED: int = 5

# Stats
@export var speed: int = DEFAULT_SPEED:
	set(value):
		speed = value
		_fixed_speed = SGFixed.from_int(value)
		
# Non-stat properties
@export var source: Node2D = null # TODO: ignore collisions/interactions with host
@export var dir_x: int = 0
@export var dir_y: int = 0
var is_deactivated: bool = false

# Fixed-point converted properties
var _fixed_speed: int = SGFixed.from_int(speed)

func advance_frame() -> void:
	var collision = move_and_collide(velocity)
	if collision:
		print(collision_layer, ": ", collision_mask)
		deactivate()
		
		var collider = collision.get_collider()
		if collider is Player:
			print("TODO: player hit")
	
	# TODO: manually check for collision if velocity is 0
	# TODO: check if that solves collisions from behind

func activate(_source: Node2D, fixed_pos_x: int, fixed_pos_y: int, _dir_x: int, _dir_y: int) -> void:
	is_deactivated = false
	
	source = _source
	
	fixed_position.x = fixed_pos_x
	fixed_position.y = fixed_pos_y
	sync_to_physics_engine()
	
	dir_x = _dir_x
	dir_y = _dir_y
	compute_velocity()
	
	set_physics_process(true)
	$SGCollisionShape2D.disabled = false
	show()

func deactivate() -> void:
	is_deactivated = true
	
	set_physics_process(false)
	$SGCollisionShape2D.disabled = true
	hide()
	
	source = null
	
	velocity.x = 0
	velocity.y = 0

func compute_velocity() -> void:
	velocity.x = dir_x * _fixed_speed
	velocity.y = dir_y * _fixed_speed
