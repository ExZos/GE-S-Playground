extends StaminaSkill

class_name SprintSkill

# States
var sprinting: bool = false
var exhausted: bool = false

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
	if exhausted: # Exhausted, prevent sprinting
		return
	
	if sprinting:
		# Key not pressed, stop sprinting
		if not (input_mask & key_bit):
			source.fp_speed_mult -= SGFixed.ONE
			sprinting = false
		# Stamina depleted, set exhausted state
		elif fp_stamina <= 0:
			source.fp_speed_mult -= SGFixed.ONE
			sprinting = false
			exhausted = true
			fp_recov_speed_mod += SGFixed.ONE
	else:
		# Key pressed, start sprinting
		if input_mask & key_bit:
			sprinting = true
			source.fp_speed_mult += SGFixed.ONE

func process_tickers() -> void:
	if sprinting:
		if fp_stamina > 0:
			fp_stamina -= SGFixed.ONE
	else:
		if fp_stamina < _fp_max_stamina:
			fp_stamina += _fp_recov_tick_speed
		elif exhausted:
			exhausted = false
			fp_recov_speed_mod -= SGFixed.ONE
