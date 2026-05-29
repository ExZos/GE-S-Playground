extends RefCounted

class_name ProjectileRequest

var source: Node2D
var type: ProjectileData.Type

var fp_pos_x: int
var fp_pos_y: int
var dir: Vector2i

func _init(_source: Node2D, _type: ProjectileData.Type, _fp_pos_x: int, _fp_pos_y: int, _dir: Vector2i):
	source = _source
	type = _type
	fp_pos_x = _fp_pos_x
	fp_pos_y = _fp_pos_y
	dir = _dir.sign()
