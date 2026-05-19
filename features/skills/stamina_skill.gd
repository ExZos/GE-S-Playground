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
var fp_stamina: int

func _ready() -> void:
	_fp_max_stamina = _fp_max_stamina
	fp_stamina = _fp_max_stamina
