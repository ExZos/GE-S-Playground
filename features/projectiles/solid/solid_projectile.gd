extends SGCharacterBody2D

class_name SolidProjectile

@export var collision_shape: SGCollisionShape2D

# Core
var source: SGFixedNode2D = null
var dir: Vector2i = Vector2i.ZERO:
	set(value):
		dir = value
		_compute_velocity()

# Stats
var fp_base_speed: int

# Stat modifier
var fp_speed_add: int = 0:
	set(value):
		fp_speed_add = value
		_speed_is_dirty = true
		
var fp_speed_mult_sum: int = SGFixed.ONE:
	set(value):
		fp_speed_mult_sum = value
		_speed_is_dirty = true

var fp_speed_mult_prod: int = SGFixed.ONE:
	set(value):
		fp_speed_mult_prod = value
		_speed_is_dirty = true
		
var _speed_is_dirty: bool = false

# Computed stats
var _fp_speed: int

# Misc - used by other nodes
var type: ProjectileData.Type = ProjectileData.Type.SOLID # Key for determining which pool it belongs to
var is_deactivated: bool = false # Reflects current state

func init(data: ProjectileData) -> void:
	type = data.type
	fp_base_speed = SGFixed.from_int(data.base_speed)
	_speed_is_dirty = true

func advance_frame() -> void:
	if _speed_is_dirty:
		_compute_speed()
		_compute_velocity()
		_speed_is_dirty = false
	
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
	fp_speed_add = 0
	fp_speed_mult_sum = SGFixed.ONE
	fp_speed_mult_prod = SGFixed.ONE
	
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
	
	velocity.clear()

func _compute_velocity() -> void:
	velocity.x = dir.x * _fp_speed
	velocity.y = dir.y * _fp_speed

func _compute_speed() -> void:
	_fp_speed = SGFixed.mul(fp_base_speed + fp_speed_add, SGFixed.mul(fp_speed_mult_sum, fp_speed_mult_prod))
	
