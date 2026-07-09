extends FixedArray

class_name DenseFixedArray

func add_item(item) -> bool:
	if count >= max_size:
		return false
	
	data[count] = item
	count += 1
	
	return true

func add_batch(batch: DenseFixedArray) -> bool:
	if batch.count > max_size - count:
		return false
	
	for i in range(batch.count):
		data[count + i] = batch.data[i]
		
	count += batch.count
	return true
