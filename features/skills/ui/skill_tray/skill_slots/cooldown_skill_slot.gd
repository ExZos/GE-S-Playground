extends Control

class_name CooldownSkillSlot

@export var progress_bar: TextureProgressBar
@export var key_label: Label
@export var timer_label: Label

@export var skill: CooldownSkill

var key_text: String

var fp_fps: float

func _ready() -> void:
	progress_bar.min_value = 0
	progress_bar.max_value = skill._fp_cooldown
	
	key_label.text = key_text

func _process(_delta: float) -> void:
	progress_bar.value = progress_bar.max_value - skill.fp_cd_ticks
	
	if progress_bar.value < progress_bar.max_value:
		timer_label.text = "%.1fs" % (skill.fp_cd_ticks / fp_fps)
	else:
		timer_label.text = ""
