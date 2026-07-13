extends FixedArray

# Use when:
# - Random deletion is a requirement
# - Data items are fire-and-forget, their transition from active to inactive is not tracked outwardly
class_name SparsePassiveArray

const ACTIVE_FLAG_NAME: StringName = &"is_active"

func _init(_max_size: int, target_script: Script) -> void:
	super(_max_size, target_script)
	
	# Check if array type has the designated active flag
	var has_active_flag: bool = false
	
	var current_script: Script = target_script
	while current_script:
		for prop: Dictionary in target_script.get_script_property_list():
			if prop["name"] == ACTIVE_FLAG_NAME:
				has_active_flag = true
				break
		
		if has_active_flag:
			break
			
		current_script = current_script.get_base_script()
	
	assert(has_active_flag, "SparsePassiveArray: Array items of type '%s' must have the property '%s'" % [target_script.get_global_name(), ACTIVE_FLAG_NAME])

# TODO: make flag check optional?
func get_next_inactive() -> Variant:
	for i in range(max_size):
		if data[i] and not data[i].is_active:
			return data[i]
	
	return null

# Does not handle filling the array
func forced_expand(debug_name: String, expand_size: int) -> void:
	if expand_size <= 0:
		push_error(debug_name, ": Array full. Expansion failed. Cannot expand by ", expand_size)
		return
	
	max_size += expand_size
	data.resize(max_size)
	
	push_warning(debug_name, ": Array full. Expanding by %d. New max_size: %d" % [expand_size, max_size])
