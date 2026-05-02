extends Node

@onready var player: Player = get_node("../Player")

const INPUT_MAP: Dictionary[StringName, int] = {
	&"ui_up": InputConstants.Bit.MOVE_UP,
	&"ui_down": InputConstants.Bit.MOVE_DOWN,
	&"ui_left": InputConstants.Bit.MOVE_LEFT,
	&"ui_right": InputConstants.Bit.MOVE_RIGHT,
	
	&"shoot_up": InputConstants.Bit.SHOOT_UP,
	&"shoot_down": InputConstants.Bit.SHOOT_DOWN,
	&"shoot_left": InputConstants.Bit.SHOOT_LEFT,
	&"shoot_right": InputConstants.Bit.SHOOT_RIGHT,
	
	&"ui_select": InputConstants.Bit.SPRINT
}

# Raw input
var _curr_raw_input_mask: int = 0
var _prev_raw_input_mask: int = 0

# Movement input history
var _last_x_input: int = 0
var _last_y_input: int = 0

func _input(event: InputEvent) -> void:
	for action in INPUT_MAP:
		if event.is_action(action):
			if event.is_pressed(): _curr_raw_input_mask |= INPUT_MAP[action]
			elif event.is_released(): _curr_raw_input_mask &= ~INPUT_MAP[action]

func _physics_process(_delta: float) -> void:
	var just_pressed_mask: int = _curr_raw_input_mask & ~_prev_raw_input_mask
	
	# Keep track of last vertical movement input
	if just_pressed_mask & InputConstants.Bit.MOVE_UP: _last_y_input = InputConstants.Bit.MOVE_UP
	elif just_pressed_mask & InputConstants.Bit.MOVE_DOWN: _last_y_input = InputConstants.Bit.MOVE_DOWN
	
	# Keep track of last horizontal movement input
	if just_pressed_mask & InputConstants.Bit.MOVE_LEFT: _last_x_input = InputConstants.Bit.MOVE_LEFT
	elif just_pressed_mask & InputConstants.Bit.MOVE_RIGHT: _last_x_input = InputConstants.Bit.MOVE_RIGHT
	
	# Determine the input mask to be used
	var input_mask: int = 0
	
	# Resolve up and down input conflicts
	if (_curr_raw_input_mask & InputConstants.BitGroup.MOVE_Y) == InputConstants.BitGroup.MOVE_Y:
		input_mask |= _last_y_input
	else:
		input_mask |= _curr_raw_input_mask & (InputConstants.BitGroup.MOVE_Y)
	
	# Resolve left and right input conflicts
	if (_curr_raw_input_mask & InputConstants.BitGroup.MOVE_X) == InputConstants.BitGroup.MOVE_X:
		input_mask |= _last_x_input
	else:
		input_mask |= _curr_raw_input_mask & (InputConstants.BitGroup.MOVE_X)
	
	# Add inputs that don't need to be resolved
	input_mask |= _curr_raw_input_mask & ~InputConstants.BitGroup.MOVE
	
	player.execute_input(input_mask)
	_prev_raw_input_mask = _curr_raw_input_mask
