extends Node

class_name PlayerInput

const INPUT_MAP: Dictionary[StringName, int] = {
	&"move_up": InputConstants.Bit.MOVE_UP,
	&"move_down": InputConstants.Bit.MOVE_DOWN,
	&"move_left": InputConstants.Bit.MOVE_LEFT,
	&"move_right": InputConstants.Bit.MOVE_RIGHT,
	
	&"atk_up": InputConstants.Bit.ATK_UP,
	&"atk_down": InputConstants.Bit.ATK_DOWN,
	&"atk_left": InputConstants.Bit.ATK_LEFT,
	&"atk_right": InputConstants.Bit.ATK_RIGHT,
	
	&"skill_1": InputConstants.Bit.SKILL_1,
	&"skill_2": InputConstants.Bit.SKILL_2,
	&"skill_3": InputConstants.Bit.SKILL_3,
	
	&"pause": InputConstants.Bit.PAUSE,
	&"respawn": InputConstants.Bit.RESPAWN,
	&"next_wave": InputConstants.Bit.NEXT_WAVE
}

# Raw input
var _prev_raw_input_mask: int

# Movement input history
var _last_x_move_input: int
var _last_y_move_input: int

# Event triggered inputs
var _pending_input_mask: int

func init() -> void:
	_prev_raw_input_mask = 0
	
	_last_x_move_input = 0
	_last_y_move_input = 0
	
	_pending_input_mask = 0
	
	GameplayEventBus.current.unpause_requested.connect(_set_unpause_input)
	GameplayEventBus.current.go_to_main_menu_requested.connect(_set_go_to_main_menu_input)

func _exit_tree() -> void:
	if GameplayEventBus.current.unpause_requested.is_connected(_set_unpause_input):
		GameplayEventBus.current.unpause_requested.disconnect(_set_unpause_input)
	
	if GameplayEventBus.current.go_to_main_menu_requested.is_connected(_set_go_to_main_menu_input):
		GameplayEventBus.current.go_to_main_menu_requested.disconnect(_set_go_to_main_menu_input)

func get_input_mask() -> int:
	var raw_input_mask: int = 0
	for action in INPUT_MAP:
		if Input.is_action_pressed(action): raw_input_mask |= INPUT_MAP[action]
	
	var just_pressed_mask: int = raw_input_mask & ~_prev_raw_input_mask
	
	# Keep track of last vertical movement input
	if just_pressed_mask & InputConstants.Bit.MOVE_UP: _last_y_move_input = InputConstants.Bit.MOVE_UP
	elif just_pressed_mask & InputConstants.Bit.MOVE_DOWN: _last_y_move_input = InputConstants.Bit.MOVE_DOWN
	
	# Keep track of last horizontal movement input
	if just_pressed_mask & InputConstants.Bit.MOVE_LEFT: _last_x_move_input = InputConstants.Bit.MOVE_LEFT
	elif just_pressed_mask & InputConstants.Bit.MOVE_RIGHT: _last_x_move_input = InputConstants.Bit.MOVE_RIGHT
	
	# The sanitized input mask to be used
	var input_mask: int = 0
	
	# Resolve up and down movement input conflicts
	if (raw_input_mask & InputConstants.BitGroup.MOVE_Y) == InputConstants.BitGroup.MOVE_Y:
		input_mask |= _last_y_move_input
	else:
		input_mask |= raw_input_mask & InputConstants.BitGroup.MOVE_Y
	
	# Resolve left and right movement input conflicts
	if (raw_input_mask & InputConstants.BitGroup.MOVE_X) == InputConstants.BitGroup.MOVE_X:
		input_mask |= _last_x_move_input
	else:
		input_mask |= raw_input_mask & InputConstants.BitGroup.MOVE_X
	
	# Add inputs that don't need to be resolved
	input_mask |= raw_input_mask & ~InputConstants.BitGroup.MOVE
	
	# Add event triggered inputs
	input_mask |= _pending_input_mask
	
	_prev_raw_input_mask = raw_input_mask
	_pending_input_mask = 0
	return input_mask

func _set_unpause_input() -> void:
	_pending_input_mask |= InputConstants.Bit.PAUSE

func _set_go_to_main_menu_input() -> void:
	_pending_input_mask |= InputConstants.Bit.GO_TO_MAIN_MENU
