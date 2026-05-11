extends Control

class_name CooldownSkillSlot

@export var progress_bar: TextureProgressBar
@export var label: Label

@export var skill: CooldownSkill
var key_text: String

func _ready() -> void:
	progress_bar.min_value = 0
	progress_bar.max_value = skill.cooldown
	
	label.text = key_text

func _process(_delta: float) -> void:
	progress_bar.value = progress_bar.max_value - skill.cd_ticks
	
	if progress_bar.value < progress_bar.max_value:
		print("COOLDOWN: ", progress_bar.value)
