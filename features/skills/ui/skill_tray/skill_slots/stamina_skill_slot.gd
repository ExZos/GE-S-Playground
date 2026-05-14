extends Control

class_name StaminaSkillSlot

@export var progress_bar: TextureProgressBar
@export var key_label: Label
@export var percentage: Label

@export var skill: StaminaSkill

var key_text: String

func _ready() -> void:
	progress_bar.min_value = 0
	progress_bar.max_value = skill.max_stamina
	
	key_label.text = key_text

func _process(_delta: float) -> void:
	progress_bar.value = skill.stamina
	
	if progress_bar.value < progress_bar.max_value:
		percentage.text = "%d%%" % (progress_bar.ratio * 100)
	else:
		percentage.text = ""
