extends RefCounted

class_name FixedArray

var data: Array
var max_size: int = 0

func _init(_max_size: int, target_script: Script) -> void:
	max_size = _max_size
	
	var target_class_name: StringName = target_script.get_instance_base_type()
	
	var base_array: Array = []
	base_array.resize(_max_size)
	
	data = Array(base_array, TYPE_OBJECT, target_class_name, target_script)
