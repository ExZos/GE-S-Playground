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
	
	var added_item_index: int = _head_next_free
	data[_head_next_free] = item
	_head_next_free = _next_free[_head_next_free]
	
	return added_item_index

func remove_item_at(index: int) -> Variant:
	if not data[index]:
		return null
	
	var removed_item: Variant = data[index]
	data[index] = null
	
	_next_free[index] = _head_next_free
	_head_next_free = index
	
	return removed_item

func remove_item(item) -> Variant:
	var index: int = data.find(item)
	if index == -1:
		return null
	
	var removed_item: Variant = data[index]
	data[index] = null
	
	_next_free[index] = _head_next_free
	_head_next_free = index
	
	return removed_item

func remove_next_item() -> Variant:
	for i in range(max_size):
		if data[i]:
			var removed_item: Variant = data[i]
			data[i] = null
			
			_next_free[i] = _head_next_free
			_head_next_free = i
			
			return removed_item
	
	return null

func forced_expand(debug_name: String, expand_size: int, is_silent: bool = false) -> void:
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
	
	if not is_silent:
		push_warning(debug_name, ": Array full. Expanding by %d. New max_size: %d" % [expand_size, max_size])
