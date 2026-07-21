extends FixedArray

# Use when:
# - Random deletion is not a consideration
# - Either:
# 	- Data is transient, it does not persist beyond a frame
# 	- Data is consumed like a stack
class_name DenseFixedArray

var count: int = 0

func add_item(item) -> int:
	if count >= max_size:
		return -1
	
	var add_index: int = count
	data[count] = item
	count += 1
	
	return add_index

func add_batch(batch: DenseFixedArray) -> bool:
	if batch.count > max_size - count:
		return false
	
	for i in range(batch.count):
		data[count + i] = batch.data[i]
		
	count += batch.count
	return true

func clear_data() -> void:
	data.fill(null)
	count = 0

func forced_expand(debug_name: String, expand_size: int) -> void:
	if expand_size <= 0:
		push_error(debug_name, ": Array full. Expansion failed. Cannot expand by ", expand_size)
		return
	
	max_size += expand_size
	data.resize(max_size)
	
	push_warning(debug_name, ": Array full. Expanding by %d. New max_size: %d" % [expand_size, max_size])
