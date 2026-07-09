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

func get_available(prop_name: StringName, target_value: bool) -> Variant:
	for i in range(max_size):
		if data[i][prop_name] == target_value:
			return data[i]
	
	return null
