extends FixedArray

# TODO: flatten array and use row_count and col_count, manually tracking 2dness
class_name SparseTypedFixedArray

var active_list: PackedInt32Array
var active_list_count: int = 0

var _next_free: PackedInt32Array
var _head_next_free: Dictionary[StringName, int] = {}

func _init(_max_size: int, target_script: Script, items: Dictionary) -> void:
	super(_max_size, target_script)
	
	active_list = PackedInt32Array()
	active_list.resize(_max_size)
	active_list.fill(-1)
	
	_next_free = PackedInt32Array()
	_next_free.resize(_max_size)
	
	var current_index: int = 0
	for key: StringName in items:
		var current_max_size = items[key].size()
		
		if current_max_size > 0:
			_head_next_free[key] = current_index
			
			for i in range(current_max_size):
				data[current_index] = items[key][i]
				_next_free[current_index] = current_index + 1
				
				current_index += 1
				
			_next_free[current_index - 1] = -1
		else:
			_head_next_free[key] = -1

func reserve_typed_item(type: StringName) -> Variant:
	if _head_next_free[type] == -1:
		return null
	
	var reserved_item_index: int = _head_next_free[type]
	_head_next_free[type] = _next_free[_head_next_free[type]]
	
	_add_to_active_list(reserved_item_index)
	
	return data[reserved_item_index]

func free_typed_item(type: StringName, index: int) -> Variant:
	if index < 0:
		return null
	
	_next_free[index] = _head_next_free[type]
	_head_next_free[type] = index
	
	_remove_from_active_list(index)
	
	return data[index]

# TODO: finish
func forced_expand(debug_name: String, expand_size: int, type: StringName) -> void:
	if expand_size <= 0:
		push_error(debug_name, ": Array full. Expansion failed. Cannot expand by ", expand_size)
		return
	
	_head_next_free[type] = max_size
	max_size += expand_size
	data.resize(max_size)
	# TODO: insert projectile object
	
	_next_free.resize(max_size)
	for i in range(_head_next_free[type], max_size - 1):
		_next_free[i] = i  + 1
	_next_free[max_size - 1] = -1
	
	active_list.resize(max_size)
	for i in range(_head_next_free[type], max_size):
		active_list[i] = -1
	
	push_warning(debug_name, ": Array full. Expanding by %d. New max_size: %d" % [expand_size, max_size])

func _add_to_active_list(index: int) -> void:
	if active_list_count >= active_list.size():
		return
	
	var insert_index: int = 0
	while insert_index < active_list_count and index > active_list[insert_index]:
		insert_index += 1
	
	for i in range(active_list_count, insert_index, -1):
		active_list[i] = active_list[i - 1]
	
	active_list[insert_index] = index
	active_list_count += 1
	
	return

func _remove_from_active_list(index: int) -> void:
	if active_list_count <= 0:
		return
	
	var remove_index: int = 0
	while remove_index < active_list_count:
		if active_list[remove_index] == index:
			break
			
		remove_index += 1
	
	if active_list[remove_index] != index:
		return
	
	for i in range(remove_index, active_list_count - 1):
		active_list[i] = active_list[i + 1]
	
	active_list_count -= 1
	active_list[active_list_count] = -1
