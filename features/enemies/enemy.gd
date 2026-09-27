extends SGCharacterBody2D

# TODO: rework enemy architecture, common parent to player script and implement simulated enemy inputs
class_name Enemy

const IS_DAMAGEABLE: bool = true

# Stats
var fp_max_hp: int

# Computed stats
var fp_current_hp: int

# Tickers
var fp_recovery_ticks: int

var is_active: bool
var is_dead: bool

# Dimensions
var fp_half_width: int

# Misc - used by other nodes
var type: StringName # Key for determining which pool it belongs to

var _normal_collision_layer: int   
var _normal_collision_mask: int

func init(data: EnemyData) -> void:
	type = data.type
	
	fp_max_hp = data.fp_max_hp
	fp_current_hp = data.fp_max_hp
	
	fp_recovery_ticks = 0
	
	is_active = false
	is_dead = false
	
	fp_half_width = data.fp_half_width
	
	_normal_collision_layer = collision_layer
	_normal_collision_mask = collision_mask

func reset() -> void:
	fp_current_hp = fp_max_hp
	is_dead = false

func advance_frame(_rng: RandomNumberGenerator) -> void:
	pass

func activate(fp_pos_x: int, fp_pos_y: int) -> void:
	is_active = true
	
	fixed_position_x = fp_pos_x
	fixed_position_y = fp_pos_y
	
	collision_layer = _normal_collision_layer
	collision_mask = _normal_collision_mask
	show()
	
	sync_to_physics_engine()

func deactivate() -> void:
	is_active = false
	
	collision_layer = 0
	collision_mask = 0
	hide()

func check_restrict_attack() -> bool:
	return false

func check_restrict_skills() -> bool:
	return false

func add_projectile_request(request: ProjectileRequest) -> void:
	print("Enemy: add projectile request") 
