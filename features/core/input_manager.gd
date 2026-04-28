extends Node

@onready var player = get_node("../SGCharacterBody2D")

var _curr_raw_input_mask: int = 0
var _prev_raw_input_mask: int = 0

# Movement input history
var _last_x_input: int = 0
var _last_y_input: int = 0

func _input(event: InputEvent) -> void:
	if event.is_action("ui_up"):
		if event.is_pressed(): _curr_raw_input_mask |= InputConstants.MOVE_UP
		else: _curr_raw_input_mask &= ~InputConstants.MOVE_UP
	
	if event.is_action("ui_down"):
		if event.is_pressed(): _curr_raw_input_mask |= InputConstants.MOVE_DOWN
		else: _curr_raw_input_mask &= ~InputConstants.MOVE_DOWN
	
	if event.is_action("ui_left"): 
		if event.is_pressed(): _curr_raw_input_mask |= InputConstants.MOVE_LEFT
		else: _curr_raw_input_mask &= ~InputConstants.MOVE_LEFT
	
	if event.is_action("ui_right"): 
		if event.is_pressed(): _curr_raw_input_mask |= InputConstants.MOVE_RIGHT
		else: _curr_raw_input_mask &= ~InputConstants.MOVE_RIGHT
	
	if(event.is_action("ui_select")):
		if event.is_pressed(): _curr_raw_input_mask |= InputConstants.SPRINT
		else: _curr_raw_input_mask &= ~InputConstants.SPRINT

func _physics_process(_delta: float) -> void:
	var just_pressed_mask: int = _curr_raw_input_mask & ~_prev_raw_input_mask
	
	# Keep track of last vertical movement input
	if just_pressed_mask & InputConstants.MOVE_UP: _last_y_input = InputConstants.MOVE_UP
	elif just_pressed_mask & InputConstants.MOVE_DOWN: _last_y_input = InputConstants.MOVE_DOWN
	
	# Keep track of last horizontal movement input
	if just_pressed_mask & InputConstants.MOVE_LEFT: _last_x_input = InputConstants.MOVE_LEFT
	elif just_pressed_mask & InputConstants.MOVE_RIGHT: _last_x_input = InputConstants.MOVE_RIGHT
	
	# Determine the input mask to be used
	var input_mask: int = 0
	
	# Resolve up and down input conflicts
	if (_curr_raw_input_mask & InputConstants.MOVE_UP) and (_curr_raw_input_mask & InputConstants.MOVE_DOWN):
		input_mask |= _last_y_input
	else:
		input_mask |= _curr_raw_input_mask & (InputConstants.MOVE_UP | InputConstants.MOVE_DOWN)
	
	# Resolve left and right input conflicts
	if (_curr_raw_input_mask & InputConstants.MOVE_LEFT) and (_curr_raw_input_mask & InputConstants.MOVE_RIGHT):
		input_mask |= _last_x_input
	else:
		input_mask |= _curr_raw_input_mask & (InputConstants.MOVE_LEFT | InputConstants.MOVE_RIGHT)
	
	# Add inputs that don't need to be resolved
	input_mask |= _curr_raw_input_mask & InputConstants.SPRINT
	
	player.execute_input(input_mask)
	_prev_raw_input_mask = _curr_raw_input_mask
