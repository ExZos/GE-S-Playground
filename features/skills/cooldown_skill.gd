extends Skill

class_name CooldownSkill

@export var cooldown: int
var _fp_cooldown: int

@export var recovery: int
var _fp_recovery: int

var fp_cd_ticks: int = 0

func _ready() -> void:
	_fp_recovery = SGFixed.from_int(recovery)
	_fp_cooldown = SGFixed.from_int(cooldown)
	fp_cd_ticks = 0
