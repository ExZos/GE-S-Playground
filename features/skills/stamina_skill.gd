extends Skill

class_name StaminaSkill

enum State { IDLE, ACTIVE, EXHAUSTED }

signal state_changed(state: State)

@export var max_stamina: int:
	set(value):
		max_stamina = value
		_fp_max_stamina = SGFixed.from_int(value)
var _fp_max_stamina: int

var state: State = State.IDLE:
	set(value):
		if state != value:
			state = value
			state_changed.emit(state)

# Stat modifiers
var fp_recov_speed_mod: int = SGFixed.TWO:
	set(value): 
		fp_recov_speed_mod = value
		_fp_recov_tick_speed = SGFixed.div(SGFixed.ONE, value)

# Computed stats
var fp_stamina: int
var _fp_recov_tick_speed: int

func _ready() -> void:
	# Execute setters
	_fp_max_stamina = _fp_max_stamina
	fp_recov_speed_mod = fp_recov_speed_mod
	
	fp_stamina = _fp_max_stamina

func advance_frame(input_mask: int, _just_pressed_mask: int, _just_released_mask: int, dir: Vector2i) -> void:
	if state == State.EXHAUSTED: # Exhausted, prevent activation
		return
	
	if state == State.ACTIVE:
		# Key not pressed, deactivate
		if not (input_mask & key_bit):
			_on_deactivate(dir)
			state = State.IDLE
		# Stamina depleted, set exhausted state
		elif fp_stamina <= 0:
			_on_exhausted(dir)
			fp_stamina = 0
			state = State.EXHAUSTED
	else:
		# Key pressed, activate
		if input_mask & key_bit:
			_on_activate(dir)
			state = State.ACTIVE

func process_tickers() -> void:
	if state == State.ACTIVE:
		if fp_stamina > 0:
			fp_stamina -= SGFixed.ONE
	elif fp_stamina < _fp_max_stamina:
		fp_stamina += _fp_recov_tick_speed
	else:
		if state == State.EXHAUSTED:
			_on_exhausted_recovery()
			state = State.IDLE
		
		fp_stamina = _fp_max_stamina

func _on_activate(_dir: Vector2i) -> void: pass
func _on_deactivate(_dir: Vector2i) -> void: pass
func _on_exhausted(_dir: Vector2i) -> void: pass
func _on_exhausted_recovery() -> void: pass
