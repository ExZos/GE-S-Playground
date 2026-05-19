extends Skill

class_name CooldownSkill

signal charges_changed(charges: int)

@export var cooldown: int
var _fp_cooldown: int

@export var recovery: int
var _fp_recovery: int

@export var max_charges: int = 1
@export var starting_charges: int = 1

var cooling_down: bool = false
var fp_cd_ticks: int = 0
var charges: int:
	set(value):
		if charges != value:
			charges = value
			charges_changed.emit(value)

func _ready() -> void:
	_fp_cooldown = SGFixed.from_int(cooldown)
	_fp_recovery = SGFixed.from_int(recovery)
	
	charges = starting_charges
