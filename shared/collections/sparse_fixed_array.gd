extends FixedArray

class_name SparseFixedArray

func add_item(item) -> bool:
	if count >= max_size:
		return false
	
	for i in range(max_size):
		if not data[i]:
			data[i] = item
			count += 1
			
			return true
	
	return false

func remove_item_at(index: int) -> bool:
	if not data[index]:
		return false
	
	data[index] = null
	count -= 1
	
	return true

func remove_item(item) -> bool:
	var index: int = data.find(item)
	if index == -1:
		return false
	
	data[index] = null
	count -= 1
	
	return true

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

func get_next_with_prop(prop_name: StringName, target_value: bool) -> Variant:
	if count >= max_size:
		return null
	
	for i in range(max_size):
		if data[i] and data[i][prop_name] == target_value:
			return data[i]
	
	return null
