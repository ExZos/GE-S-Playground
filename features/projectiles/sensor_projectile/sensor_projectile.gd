extends SGArea2D

# TODO: use ProjectileData
class_name SensorProjectile

@export var collision_shape: SGCollisionShape2D

# Default stats
const DEFAULT_SPEED: int = 5

# Stats
@export var speed: int = DEFAULT_SPEED:
	set(value):
		speed = value
		_fixed_speed = SGFixed.from_int(value)
		
# Non-stat properties
var source_scene: PackedScene = null
@export var source: Node2D = null
@export var dir_x: int = 0
@export var dir_y: int = 0
var is_deactivated: bool = false

# Fixed-point converted properties
var _fixed_speed: int = SGFixed.from_int(speed)

func advance_frame() -> void:
	fixed_position_x += dir_x * _fixed_speed
	fixed_position_y += dir_y * _fixed_speed
	sync_to_physics_engine()
	
	var overlaping_bodies: Array = get_overlapping_bodies()
	for body: Node2D in overlaping_bodies:
		if body == source:
			print("SOURCE")
			return;	
		elif body is Player:
			print("TODO: player hit")
			
		deactivate()
	
	#if collision:
		#var collider: Node2D = collision.get_collider()
		#
		#if collider == source:
			#print("SOURCE")
			#return;
		#elif collider is Player:
			#print("TODO: player hit")
		#
		#deactivate()

func activate(_source: Node2D, fixed_pos_x: int, fixed_pos_y: int, _dir_x: int, _dir_y: int) -> void:
	is_deactivated = false
	
	source = _source
	
	fixed_position.x = fixed_pos_x
	fixed_position.y = fixed_pos_y
	sync_to_physics_engine()
	
	dir_x = _dir_x
	dir_y = _dir_y
	#compute_velocity()
	
	set_physics_process(true)
	collision_shape.disabled = false
	show()

func deactivate() -> void:
	is_deactivated = true
	
	set_physics_process(false)
	collision_shape.disabled = true
	hide()
	
	source = null
	
	#velocity.x = 0
	#velocity.y = 0
