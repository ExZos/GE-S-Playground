extends FixedArray

class_name DenseFixedArray

func add_item(item) -> int:
	if count >= max_size:
		return false
	
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
