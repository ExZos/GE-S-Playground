extends FixedArray

class_name SparseFixedArray

var _next_free: PackedInt64Array
var _head_next_free: int = 0

func _init(_max_size: int, target_script: Script) -> void:
	super(_max_size, target_script)
	
	_next_free = PackedInt64Array()
	if max_size > 0:
		_next_free.resize(_max_size)
		for i in range(_max_size):
			_next_free[i] = i + 1
		_next_free[_max_size - 1] = -1
	else:
		_head_next_free = -1

# --- Functions for a nullable array ---
func add_item(item) -> int:
	if _head_next_free == -1:
		return -1
	
	var add_index: int = _head_next_free
	data[_head_next_free] = item
	_head_next_free = _next_free[_head_next_free]
	
	count += 1
	return add_index

func remove_item_at(index: int) -> int:
	if not data[index]:
		return -1
	
	data[index] = null
	_next_free[index] = _head_next_free
	_head_next_free = index
	
	count -= 1
	return index

func remove_item(item) -> int:
	var index: int = data.find(item)
	if index == -1:
		return false
	
	data[index] = null
	_next_free[index] = _head_next_free
	_head_next_free = index
	
	count -= 1
	return true

# --- Functions for a pooled array
#  

# --- Functions with more control ---
# PROGRESS OF NEXT_FREE IMPLEMENTAITON
func get_next_empty_index() -> int:
	if count >= max_size:
		return -1
	
	for i in range(max_size):
		if not data[i]:
			return i
	
	return -1

func get_next_filled_index() -> int:
	if count <= 0:
		return -1
	
	for i in range(max_size):
		if data[i]:
			return i
	
	return -1

# --- Fallback functions ---
# TODO: handle forced expansion with non nulls
func forced_expand(debug_name: String, expand_size: int) -> void:
	if expand_size <= 0:
		push_error(debug_name, ": Array full. Expansion failed. Cannot expand by ", expand_size)
		return
	
	_head_next_free = max_size
	max_size += expand_size
	data.resize(max_size)
	
	_next_free.resize(max_size)
	for i in range(_head_next_free, max_size - 1):
		_next_free[i] = i  + 1
	_next_free[max_size - 1] = -1
	
	push_warning(debug_name, ": Array full. Expanding by %d. New max_size: %d" % [expand_size, max_size])
