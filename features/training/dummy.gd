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

func init() -> void:
	fp_max_hp = SGFixed.from_int(max_hp)
	fp_respawn_time = SGFixed.from_int(respawn_time)
	
	fp_current_hp = fp_max_hp
	is_dead = false

func reset() -> void:
	fp_current_hp = fp_max_hp
	is_dead = false

func advance_frame() -> void:
	if _fp_respawn_ticks > 0:
		_fp_respawn_ticks -= SGFixed.ONE
		
		if _fp_respawn_ticks <= 0:
			reset()
			on_respawn()

func on_death() -> void:
	set_physics_process(false)
	collision_shape.disabled = true
	collision_shape.hide()
	
	_fp_respawn_ticks = fp_respawn_time
	
	sync_to_physics_engine()

func on_respawn() -> void:
	set_physics_process(true)
	collision_shape.disabled = false
	collision_shape.show()
	
	sync_to_physics_engine()
