extends RefCounted

class_name ProjectileRequest

var source: Node2D
var data: ProjectileData

var fixed_pos_x: int
var fixed_pos_y: int
var dir: Vector2i

func _init(_source: Node2D, _data: ProjectileData, _fixed_pos_x: int, _fixed_pos_y: int, _dir: Vector2i):
	source = _source
	data = _data
	fixed_pos_x = _fixed_pos_x
	fixed_pos_y = _fixed_pos_y
	dir = _dir.sign()
