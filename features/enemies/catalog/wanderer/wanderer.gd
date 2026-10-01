@tool
extends Enemy

class_name Wanderer

const INDEX_SHIFTS: PackedInt32Array = [-1, 1]

var move_dir_index: int
var move_dir_index_shift: int

func init(data: CharacterData) -> void:
	super(data)
	
	move_dir_index = -1
