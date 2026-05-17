extends SGCharacterBody2D

class_name SolidProjectile

@export var collision_shape: SGCollisionShape2D

# Core
var source: SGFixedNode2D = null
var dir: Vector2i = Vector2i.ZERO

# Stats
var fp_base_speed: int:
	set(value):
		fp_base_speed = value
		_compute_speed()

# Stat modifier
var fp_speed_mult: int = SGFixed.ONE:
	set(value):
		fp_speed_mult = value
		_compute_speed()

# Computed stats
var _fp_speed: int

# Misc - used by other nodes
var source_scene: PackedScene = null # Key for determining which pool it belongs to
var is_deactivated: bool = false # Reflects current state

func init(data: ProjectileData) -> void:
	fp_base_speed = SGFixed.from_int(data.speed)
	fp_speed_mult = fp_speed_mult

func advance_frame() -> void:
	var collision = move_and_collide(velocity)
	
	if collision:
		var collider: SGFixedNode2D = collision.get_collider()
		
		if collider == source:
			print("SolidProjectile: Hit self")
			return;
		elif collider is Player:
			print("SolidProjectile: Hit player")
		
		deactivate()

func activate(_source: SGFixedNode2D, fp_pos_x: int, fp_pos_y: int, _dir: Vector2i) -> void:
	is_deactivated = false
	
	source = _source
	
	fixed_position.x = fp_pos_x
	fixed_position.y = fp_pos_y
	sync_to_physics_engine()
	
	dir = _dir
	compute_velocity()
	
	set_physics_process(true)
	collision_shape.disabled = false
	show()

func deactivate() -> void:
	is_deactivated = true
	
	set_physics_process(false)
	collision_shape.disabled = true
	hide()
	
	source = null
	
	velocity.clear()

func compute_velocity() -> void:
	velocity.x = dir.x * _fp_speed
	velocity.y = dir.y * _fp_speed

func _compute_speed() -> void:
	_fp_speed = SGFixed.mul(fp_base_speed, fp_speed_mult)
