extends SGCharacterBody2D

# TODO: basic reactions to input that would be common for all characters (movement, shooting?, skills?, etc)
# TODO: make enemy inherit this
class_name Character

@export var character_data: CharacterData
@export var collision_shape: SGCollisionShape2D

const IS_DAMAGEABLE: bool = true

# Stats
var fp_max_hp: int
var fp_base_speed: int

# Computed stats
var fp_current_hp: int
var _fp_speed: int

# Stat modifiers
var fp_speed_add: int = 0
var fp_speed_mult_sum: int = SGFixed.ONE
var fp_speed_mult_prod: int = SGFixed.ONE

# Core state
var is_active: bool = false
var is_dead: bool = false
var _normal_collision_layer: int   
var _normal_collision_mask: int

# Restriction states
var is_recovering: bool = false
var restrict_attack: bool = false
var restrict_skills: bool = false

# Tickers
var fp_recovery_ticks: int = 0

# Movement
var mov_dir: Vector2i = Vector2i.ZERO
var forced_mov_dir: Vector2i = Vector2i.ZERO

# Dimensions
var fp_half_width: int:
	get:
		return collision_shape.shape.radius

func init() -> void:
	fp_max_hp = character_data.fp_max_hp
	fp_current_hp = character_data.fp_max_hp
	
	fp_base_speed = character_data.fp_base_speed
	_compute_speed()
	
	is_active = true
	is_dead = false
	
	_normal_collision_layer = collision_layer
	_normal_collision_mask = collision_mask

func reset() -> void:
	fp_max_hp = character_data.fp_max_hp
	fp_current_hp = character_data.fp_max_hp
	
	fp_base_speed = character_data.fp_base_speed
	_compute_speed()
	
	is_dead = false

func activate(fp_pos_x: int, fp_pos_y: int) -> void:
	reset()
	
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

# --- Restriction state utilities ---
func check_restrict_attack() -> bool:
	return restrict_attack or is_recovering

func check_restrict_skills() -> bool:
	return restrict_skills or is_recovering

# ---  ---
func _compute_speed() -> void:
	_fp_speed = SGFixed.mul(fp_base_speed + fp_speed_add, SGFixed.mul((fp_speed_mult_sum), fp_speed_mult_prod))
