extends SGArea2D

class_name SensorProjectile

@export var collision_shape: SGCollisionShape2D

# Core
var source: SGFixedNode2D = null
var dir: Vector2i

# Stats
var fp_base_speed: int:
	set(value):
		fp_base_speed = value
		_compute_speed()

# Stat multipliers
var fp_speed_mult: int = SGFixed.ONE:
	set(value):
		fp_speed_mult = value
		_compute_speed()

# Computed stats
var _fp_speed: int

# Misc - used by other nodes
var type: ProjectileData.Type # Key for determining which pool it belongs to
var is_deactivated: bool = false # Reflects current state

func init(data: ProjectileData) -> void:
	type = data.type
	fp_base_speed = SGFixed.from_int(data.speed)

func advance_frame() -> void:
	fixed_position_x += dir.x * _fp_speed
	fixed_position_y += dir.y * _fp_speed
	sync_to_physics_engine()
	
	var overlaping_bodies: Array = get_overlapping_bodies()
	for body: SGFixedNode2D in overlaping_bodies:
		if body == source:
			print("SensorProjectile: Hit self")
			return;	
		elif body is Player:
			print("SensorProjectile: Hit player")
			
		deactivate()

func activate(_source: SGFixedNode2D, fp_pos_x: int, fp_pos_y: int, _dir: Vector2i) -> void:
	fp_speed_mult = SGFixed.ONE
	
	is_deactivated = false
	
	source = _source
	
	fixed_position.x = fp_pos_x
	fixed_position.y = fp_pos_y
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

func _compute_speed() -> void:
	_fp_speed = SGFixed.mul(fp_base_speed, fp_speed_mult)
