extends RefCounted

class_name ProjectileModifier

var source: Character
var skill: Skill

func _init(_source: Character, _skill: Skill) -> void:
	source = _source
	skill = _skill

func apply(_projectiles: SparseTypedFixedArray) -> void:
	pass

func check_applied() -> void:
	pass
