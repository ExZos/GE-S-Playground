extends SGCharacterBody2D

class_name Enemy

const IS_DAMAGEABLE: bool = true

var fp_max_hp: int
var fp_current_hp: int

var is_active: bool
var is_dead: bool

# Misc - used by other nodes
var type: StringName # Key for determining which pool it belongs to

var _normal_collision_layer: int   
var _normal_collision_mask: int

func init(data: EnemyData) -> void:
	type = data.type
	fp_max_hp = SGFixed.from_int(data.max_hp)
	
	fp_current_hp = fp_max_hp
	is_active = false
	is_dead = false
	
	_normal_collision_layer = collision_layer
	_normal_collision_mask = collision_mask

func reset() -> void:
	fp_current_hp = fp_max_hp
	is_dead = false

func advance_frame() -> void:
	pass

# TODO: position params
func activate() -> void:
	is_active = true
	
	collision_layer = _normal_collision_layer
	collision_mask = _normal_collision_mask
	show()

func deactivate() -> void:
	is_active = false
	
	collision_layer = 0
	collision_mask = 0
	hide()
