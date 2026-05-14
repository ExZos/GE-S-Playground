extends Control

class_name CooldownSkillSlot

@export var progress_bar: TextureProgressBar
@export var key_label: Label
@export var timer_label: Label

@export var skill: CooldownSkill

var key_text: String

var _float_fps: float

func _ready() -> void:
	progress_bar.min_value = 0
	progress_bar.max_value = skill.cooldown
	
	key_label.text = key_text

func _process(_delta: float) -> void:
	progress_bar.value = progress_bar.max_value - skill.cd_ticks
	
	if progress_bar.value < progress_bar.max_value:
		timer_label.text = "%.1fs" % (skill.cd_ticks / _float_fps)
	else:
		timer_label.text = ""
