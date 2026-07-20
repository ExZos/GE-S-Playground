extends RefCounted

class_name ProjectileModifier

var source: SGFixedNode2D
var skill: Skill

func _init(_source: SGFixedNode2D, _skill: Skill) -> void:
	source = _source
	skill = _skill

func apply(_projectiles: SparseTypedFixedArray) -> void:
	pass

func check_applied() -> void:
	pass
