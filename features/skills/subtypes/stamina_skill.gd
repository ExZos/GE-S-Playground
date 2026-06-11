extends Skill

class_name StaminaSkill

enum State { IDLE, ACTIVE, EXHAUSTED }

signal state_changed(state: State)

var state: State = State.IDLE:
	set(value):
		if state != value:
			state = value
			state_changed.emit(state)

# Stats
var _fp_max_stamina: int
var _fp_recov_speed_div_inc: int

# Stat modifiers
var fp_recov_speed_div: int:
	set(value): 
		fp_recov_speed_div = value
		_fp_recov_tick_speed = SGFixed.div(SGFixed.ONE, value)

# Computed stats
var fp_stamina: int
var _fp_recov_tick_speed: int

func init(data: SkillData) -> void:
	for feature in data.features:
		_process_feature(feature)

func _process_feature(feature: SkillFeature) -> void:
	match feature.get_feature_type():
		&"stamina":
			_fp_max_stamina = SGFixed.from_int(feature.max_stamina)
			fp_recov_speed_div = SGFixed.from_int(feature.base_recov_speed_div)
			_fp_recov_speed_div_inc = SGFixed.from_int(feature.recov_speed_div_inc)

func _ready() -> void:
	# Start with max stamina
	fp_stamina = _fp_max_stamina

func advance_frame(input_mask: int, _just_pressed_mask: int, _just_released_mask: int, mov_dir: Vector2i, aim_dir: Vector2i) -> void:
	if state == State.EXHAUSTED: # Exhausted, prevent activation
		return
	
	if state == State.ACTIVE:
		# Key not pressed, deactivate
		if not (input_mask & key_bit):
			_on_deactivate(mov_dir, aim_dir)
			state = State.IDLE
		# Stamina depleted, set exhausted state
		elif fp_stamina <= 0:
			_on_exhausted(mov_dir, aim_dir)
			fp_stamina = 0
			state = State.EXHAUSTED
	else:
		# Key pressed, activate
		if input_mask & key_bit:
			_on_activate(mov_dir, aim_dir)
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

func _on_activate(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void: pass
func _on_deactivate(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void: pass

func _on_exhausted(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	fp_recov_speed_div += _fp_recov_speed_div_inc # TODO: add this as a modifier instead

func _on_exhausted_recovery() -> void:
	fp_recov_speed_div -= _fp_recov_speed_div_inc
