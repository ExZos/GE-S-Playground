extends Skill

class_name StaminaSkill

@export var max_stamina: int:
	set(value):
		max_stamina = value
		_fp_max_stamina = SGFixed.from_int(value)
var _fp_max_stamina: int

var fp_stamina: int

func _ready() -> void:
	_fp_max_stamina = _fp_max_stamina
	fp_stamina = _fp_max_stamina
