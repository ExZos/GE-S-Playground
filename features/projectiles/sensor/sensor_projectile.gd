extends SGArea2D

class_name SensorProjectile

@export var collision_shape: SGCollisionShape2D

# Core
var source: SGFixedNode2D = null
var dir: Vector2i

# Misc - used by other nodes
var source_scene: PackedScene = null # Key for determining which pool it belongs to
var is_deactivated: bool = false # Reflects current state

# Stats
var _fixed_speed: int
var _recovery_ticks: int = 0

func init(data: ProjectileData) -> void:
	_fixed_speed = SGFixed.from_int(data.speed)
	_recovery_ticks = data.recovery_ticks

func advance_frame() -> void:
	fixed_position_x += dir.x * _fixed_speed
	fixed_position_y += dir.y * _fixed_speed
	sync_to_physics_engine()
	
	var overlaping_bodies: Array = get_overlapping_bodies()
	for body: SGFixedNode2D in overlaping_bodies:
		if body == source:
			print("SensorProjectile: Hit self")
			return;	
		elif body is Player:
			print("SensorProjectile: Hit player")
			
		deactivate()

func activate(_source: SGFixedNode2D, fixed_pos_x: int, fixed_pos_y: int, _dir: Vector2i) -> void:
	is_deactivated = false
	
	source = _source
	
	fixed_position.x = fixed_pos_x
	fixed_position.y = fixed_pos_y
	sync_to_physics_engine()
	
	dir = _dir
	
	set_physics_process(true)
	collision_shape.disabled = false
	show()

func deactivate() -> void:
	is_deactivated = true
	
	set_physics_process(false)
	collision_shape.disabled = true
	hide()
	
	source = null
