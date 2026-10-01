extends Node

class_name EnemyInput

func get_input_mask(_enemy: Enemy, prev_input_mask: int) -> int:
	return prev_input_mask

func handle_collision(_enemy: Enemy, input_mask) -> int:
	return input_mask
