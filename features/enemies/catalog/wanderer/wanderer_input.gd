extends EnemyInput

class_name WandererInput

func get_input_mask(enemy: Enemy, prev_input_mask: int) -> int:
	if not enemy.can_move():
		return prev_input_mask
	
	enemy.move_dir_index = EventBus.get_randi_range(0, InputConstants.BitList.MOVE.size() - 1)
	enemy.move_dir_index_shift = enemy.INDEX_SHIFTS[EventBus.get_randi_range(0, enemy.INDEX_SHIFTS.size() - 1)]
	var move_input = InputConstants.BitList.MOVE[enemy.move_dir_index]
	
	print("NEW MOVE: %dms" % SGFixed.to_int(enemy.fp_move_ticks))
	
	return 0 | move_input

func handle_collision(enemy: Enemy, input_mask: int) -> int:
	var new_input_mask: int = input_mask & ~InputConstants.BitGroup.MOVE
	
	enemy.move_dir_index = posmod(enemy.move_dir_index + enemy.move_dir_index_shift, InputConstants.BitList.MOVE.size())
	new_input_mask |= InputConstants.BitList.MOVE[enemy.move_dir_index]
	
	return new_input_mask
