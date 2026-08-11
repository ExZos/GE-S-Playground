extends SGStaticBody2D

class_name Dummy

const IS_DAMAGEABLE: bool = true

@export var collision_shape: SGCollisionShape2D

@export var max_hp: int
var fp_max_hp: int

@export var respawn_time: int
var fp_respawn_time: int

var fp_current_hp: int
var is_dead: bool
var _fp_respawn_ticks: int

var _normal_collision_layer: int
var _normal_collision_mask: int

# Presentation logic params
var _was_dead_visually: bool

func init() -> void:
	fp_max_hp = SGFixed.from_int(max_hp)
	fp_respawn_time = SGFixed.from_int(respawn_time)
	
	fp_current_hp = fp_max_hp
	is_dead = false
	_was_dead_visually = is_dead
	
	_normal_collision_layer = collision_layer
	_normal_collision_mask = collision_mask

func reset() -> void:
	fp_current_hp = fp_max_hp
	is_dead = false

func advance_frame() -> void:
	if _fp_respawn_ticks > 0:
		_fp_respawn_ticks -= SGFixed.ONE
		
		if _fp_respawn_ticks <= 0:
			reset()
			on_respawn()

func _process(_delta: float) -> void:
	if is_dead != _was_dead_visually:
		collision_shape.visible = !is_dead
		_was_dead_visually = is_dead

func on_death() -> void:
	collision_layer = 0
	collision_mask = 0
	
	_fp_respawn_ticks = fp_respawn_time

func on_respawn() -> void:
	collision_layer = _normal_collision_layer
	collision_mask = _normal_collision_mask
