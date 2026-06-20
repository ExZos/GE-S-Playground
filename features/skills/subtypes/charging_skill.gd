extends Skill

class_name ChargingSkill

signal state_changed(state: State)

enum State { IDLE, CHARGING, COOLDOWN }

var state: State = State.IDLE:
	set(value):
		if state != value:
			state = value
			state_changed.emit(value)

# Stats
var _fp_charge_time: int
var _fp_cooldown: int

# Tickers
var fp_cd_ticks: int = 0
var fp_charge_ticks: int = 0

func _process_feature(feature: SkillFeature) -> void:
	match feature.get_feature_type():
		ChargingFeature.TYPE:
			_fp_charge_time = SGFixed.from_int(feature.charge_time)
		
		CooldownFeature.TYPE:
			_fp_cooldown = SGFixed.from_int(feature.cooldown)
		
		_: super(feature)

func advance_frame(input_mask: int, _just_pressed_mask: int, _just_released_mask: int, mov_dir: Vector2i, aim_dir: Vector2i) -> void:
	if state == State.COOLDOWN:
		return
	
	if state == State.CHARGING:
		# Key not pressed, check if fully charged
		if not (input_mask & key_bit):
			if fp_charge_ticks >= _fp_charge_time and _can_activate(mov_dir, aim_dir): # Full charged, activate
				_on_activate(mov_dir, aim_dir)
				fp_cd_ticks += _fp_cooldown
				state = State.COOLDOWN
			else: 
				_on_charging_cancelled(mov_dir, aim_dir)
				state = State.IDLE
			
			fp_charge_ticks = 0
	else:
		# Key pressed, start charging
		if input_mask & key_bit and not check_restricted.call():
			_on_charging_start(mov_dir, aim_dir)
			state = State.CHARGING

func process_tickers() -> void:
	if state == State.COOLDOWN:
		if fp_cd_ticks > 0:
			fp_cd_ticks -= SGFixed.ONE
		
		if fp_cd_ticks <= 0:
			fp_cd_ticks = 0
			state = State.IDLE
	elif state == State.CHARGING and fp_charge_ticks < _fp_charge_time:
		fp_charge_ticks += SGFixed.ONE

func _can_activate(_mov_dir: Vector2i, _aim_dir: Vector2i) -> bool: return true
func _on_activate(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void: pass
func _on_charging_start(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void: pass
func _on_charging_cancelled(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void: pass
