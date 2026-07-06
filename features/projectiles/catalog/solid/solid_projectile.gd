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
var type: StringName = RegistryKeys.Projectiles.SOLID_PROJECTILE # Key for determining which pool it belongs to
var is_deactivated: bool = false # Reflects current state

var _bubble_vfx_event: BubbleVFXEvent

func init(data: ProjectileData) -> void:
	type = data.type
	fp_base_speed = SGFixed.from_int(data.base_speed)
	_speed_is_dirty = true
	
	_bubble_vfx_event = BubbleVFXEvent.new(
		Vector2i.ZERO,
		Vector2i.ZERO,
		0
	)

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
		
		_bubble_vfx_event.pos = position
		_bubble_vfx_event.dir = dir
		EventBus.vfx_requested.emit(_bubble_vfx_event)
		
		deactivate()

func activate(_source: SGFixedNode2D, fp_pos_x: int, fp_pos_y: int, _dir: Vector2i) -> void:
	is_deactivated = false
	
	source = _source
	
	fixed_position.x = fp_pos_x
	fixed_position.y = fp_pos_y
	dir = _dir
	
	set_physics_process(true)
	collision_shape.disabled = false
	show()
	
	sync_to_physics_engine()

func deactivate() -> void:
	is_deactivated = true

func reset() -> void:
	source = null
	
	fp_speed_add = 0
	fp_speed_mult_sum = SGFixed.ONE
	fp_speed_mult_prod = SGFixed.ONE
	
	fixed_position.clear()
	dir = Vector2i.ZERO
	velocity.clear()
	
	set_physics_process(false)
	collision_shape.disabled = true
	hide()
	
	sync_to_physics_engine()

func _compute_velocity() -> void:
	velocity.x = dir.x * _fp_speed
	velocity.y = dir.y * _fp_speed

func _compute_speed() -> void:
	_fp_speed = SGFixed.mul(fp_base_speed + fp_speed_add, SGFixed.mul(fp_speed_mult_sum, fp_speed_mult_prod))
	
