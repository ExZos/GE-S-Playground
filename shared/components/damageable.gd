extends Node

class_name Damageable

var max_hp: int
var current_hp: int

var is_dead: bool

func init(_max_hp: int) -> void:
	assert(_max_hp > 0, "Damageable: Max HP must be > 0")
	
	max_hp = _max_hp
	current_hp = _max_hp
	
	is_dead = false

func take_damage(damage: int) -> void:
	current_hp = max(current_hp - damage, 0)
	
	if current_hp <= 0:
		is_dead = true

func reset() -> void:
	current_hp = max_hp
	is_dead = false
