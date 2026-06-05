extends RefCounted

class_name PlayerModifier

var source: SGFixedNode2D
var _fp_duration_ticks: int = 0

func _init(_source: SGFixedNode2D, fp_duration: int) -> void:
		source = _source
		_fp_duration_ticks = fp_duration
	
func apply_and_check() -> bool:
	return _tick_and_check()

func _tick_and_check() -> bool:
	_fp_duration_ticks -= SGFixed.ONE
	return _fp_duration_ticks > 0
