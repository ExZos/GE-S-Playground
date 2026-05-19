extends StaminaSkill

class_name SprintSkill

# Stat modifiers
var fp_recov_speed_mod: int = SGFixed.TWO:
	set(value): 
		fp_recov_speed_mod = value
		_fp_recov_tick_speed = SGFixed.div(SGFixed.ONE, value)

# Computed stats
var _fp_recov_tick_speed: int

func _ready() -> void:
	super()
	fp_recov_speed_mod = fp_recov_speed_mod

func advance_frame(source: Player, input_mask: int, _just_pressed_mask: int, _just_released_mask: int, _dir: Vector2i) -> void:
	if state == State.EXHAUSTED: # Exhausted, prevent sprinting
		return
	
	if state == State.ACTIVE:
		# Key not pressed, stop sprinting
		if not (input_mask & key_bit):
			source.fp_speed_mult -= SGFixed.ONE
			state = State.IDLE
		# Stamina depleted, set exhausted state
		elif fp_stamina <= 0:
			fp_stamina = 0
			source.fp_speed_mult -= SGFixed.ONE
			fp_recov_speed_mod += SGFixed.ONE
			state = State.EXHAUSTED
	else:
		# Key pressed, start sprinting
		if input_mask & key_bit:
			state = State.ACTIVE
			source.fp_speed_mult += SGFixed.ONE

func process_tickers() -> void:
	if state == State.ACTIVE:
		if fp_stamina > 0:
			fp_stamina -= SGFixed.ONE
	elif fp_stamina < _fp_max_stamina:
		fp_stamina += _fp_recov_tick_speed
	else:
		if state == State.EXHAUSTED:
			state = State.IDLE
			fp_recov_speed_mod -= SGFixed.ONE
		
		fp_stamina = _fp_max_stamina
