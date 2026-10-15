extends RefCounted

class_name CharacterModifier

var source: Character
var _fp_duration_ticks: int = 0

func _init(_source: Character, fp_duration: int) -> void:
	source = _source
	_fp_duration_ticks = fp_duration

func apply() -> void:
	pass

func tick_and_check() -> bool:
	_fp_duration_ticks -= SGFixed.ONE
	return _fp_duration_ticks > 0
