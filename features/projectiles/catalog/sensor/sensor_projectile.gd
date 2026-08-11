extends SGArea2D

class_name SensorProjectile

@export var collision_shape: SGCollisionShape2D

# Core
var source: SGFixedNode2D
var dir: Vector2i

# Stats
var fp_base_speed: int
var fp_base_damage: int

# Stat modifier
var fp_speed_add: int:
	set(value):
		fp_speed_add = value
		_speed_is_dirty = true
		
var fp_speed_mult_sum: int:
	set(value):
		fp_speed_mult_sum = value
		_speed_is_dirty = true

var fp_speed_mult_prod: int:
	set(value):
		fp_speed_mult_prod = value
		_speed_is_dirty = true
		
var _speed_is_dirty: bool

# Computed stats
var _fp_speed: int

# Misc - used by other nodes
var type: StringName = RegistryKeys.Projectiles.SENSOR_PROJECTILE # Key for determining which pool it belongs to
var is_active: bool

var _normal_collision_layer: int
var _normal_collision_mask: int

var _bubble_vfx_event: BubbleVFXEvent

func init(data: ProjectileData) -> void:
	type = data.type
	fp_base_speed = SGFixed.from_int(data.base_speed)
	fp_base_damage = SGFixed.from_int(data.base_damage)
	
	fp_speed_add = 0
	fp_speed_mult_sum = SGFixed.ONE
	fp_speed_mult_prod = SGFixed.ONE
	
	is_active = false
	_speed_is_dirty = true
	
	_normal_collision_layer = collision_layer
	_normal_collision_mask = collision_mask
	
	_bubble_vfx_event = BubbleVFXEvent.new(
		Vector2i.ZERO,
		Vector2i.ZERO,
		0
	)

func advance_frame() -> void:
	if _speed_is_dirty:
		_compute_speed()
		_speed_is_dirty = false
	
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
		
		# TODO: compute fp_damage
		DamageSystem.apply_damage(body, fp_base_damage)
		
		_bubble_vfx_event.pos = position
		_bubble_vfx_event.dir = dir
		EventBus.vfx_requested.emit(_bubble_vfx_event)
		
		deactivate()

func activate(_source: SGFixedNode2D, fp_pos_x: int, fp_pos_y: int, _dir: Vector2i) -> void:
	is_active = true
	
	source = _source
	
	fixed_position.x = fp_pos_x
	fixed_position.y = fp_pos_y
	dir = _dir
	
	collision_layer = _normal_collision_layer
	collision_mask = _normal_collision_mask
	show()
	
	sync_to_physics_engine()

func deactivate() -> void:
	is_active = false
	
	collision_layer = 0
	collision_mask = 0
	hide()

func reset() -> void:
	source = null
	
	fp_speed_add = 0
	fp_speed_mult_sum = SGFixed.ONE
	fp_speed_mult_prod = SGFixed.ONE
	
	fixed_position.clear()
	dir = Vector2i.ZERO
	
	sync_to_physics_engine()

func _compute_speed() -> void:
	_fp_speed = SGFixed.mul(fp_base_speed + fp_speed_add, SGFixed.mul(fp_speed_mult_sum, fp_speed_mult_prod))
