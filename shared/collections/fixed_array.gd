extends RefCounted

class_name FixedArray

var data: Array
var max_size: int = 0

var default_value: Variant = null

func _init(_max_size: int, type: Variant, target_script: Script = null) -> void:
	max_size = _max_size
	
	var target_class_name: StringName = &""
	if type == TYPE_OBJECT:
		target_class_name = target_script.get_instance_base_type()
	
	match type:
		TYPE_INT: default_value = 0
		TYPE_FLOAT: default_value = 0.0
		TYPE_STRING, TYPE_STRING_NAME: default_value = &""
		TYPE_BOOL: default_value = false
	
	var base_array: Array = []
	base_array.resize(_max_size)
	if default_value != null:
		base_array.fill(default_value)
	
	data = Array(base_array, type, target_class_name, target_script)
