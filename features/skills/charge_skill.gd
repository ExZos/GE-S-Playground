extends Skill

class_name ChargeSkill

signal state_changed(state: State)

enum State { IDLE, CHARGING, COOLDOWN }

@export var charge_time: int
var _fp_charge_time: int

@export var cooldown: int
var _fp_cooldown: int

@export var recovery: int
var _fp_recovery: int

var state: State = State.IDLE:
	set(value):
		if state != value:
			state = value
			state_changed.emit(value)
var fp_cd_ticks: int = 0
var fp_charge_ticks: int = 0

func _ready() -> void:
	_fp_charge_time = SGFixed.from_int(charge_time)
	_fp_cooldown = SGFixed.from_int(cooldown)
	_fp_recovery = SGFixed.from_int(recovery)

func advance_frame(input_mask: int, _just_pressed_mask: int, _just_released_mask: int, dir: Vector2i) -> void:
	if state == State.COOLDOWN:
		return
	
	if state == State.CHARGING:
		# Key not pressed, check if fully charged
		if not (input_mask & key_bit):
			if fp_charge_ticks >= _fp_charge_time: # Full charged, activate
				_on_activate(dir)
				fp_cd_ticks += _fp_cooldown
				state = State.COOLDOWN
			else: 
				_on_charging_cancelled(dir)
				state = State.IDLE
			
			fp_charge_ticks = 0
	else:
		# Key pressed, start charging
		if input_mask & key_bit:
			_on_charging_start(dir)
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

func _on_activate(_dir: Vector2i) -> void: pass
func _on_charging_start(_dir: Vector2i) -> void: pass
func _on_charging_cancelled(_dir: Vector2i) -> void: pass
