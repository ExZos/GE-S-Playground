extends RefCounted

class_name ProjectileRequest

var source: Node2D
var type: StringName

var fp_pos_x: int = 0
var fp_pos_y: int = 0
var dir: Vector2i = Vector2i.ZERO

func _init(_source: Node2D, _type: StringName) -> void:
	source = _source
	type = _type

func set_trajectory(_fp_pos_x: int, _fp_pos_y: int, _dir: Vector2i) -> void:
	fp_pos_x = _fp_pos_x
	fp_pos_y = _fp_pos_y
	dir = _dir.sign()
