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
