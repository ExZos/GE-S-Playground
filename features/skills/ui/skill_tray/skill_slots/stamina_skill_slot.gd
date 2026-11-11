extends Control

class_name StaminaSkillSlot

@onready var progress_bar: TextureProgressBar = $MarginContainer/ProgressBarContainer/TextureProgressBar
@onready var key_label: Label = $Key
@onready var percentage_label: Label = $MarginContainer/Percentage

var fp_fps: int

var key_text: String:
	set(value):
		key_label.text = value
	
	get():
		return key_label.text

var state: StaminaSkill.State:
	set(value):
		state = value
		
		if value == StaminaSkill.State.EXHAUSTED:
			progress_bar.tint_progress = Color.GRAY
		else:
			progress_bar.tint_progress = Color.WHITE

var fp_max_stamina: int:
	set(value):
		progress_bar.max_value = value
	
	get():
		return int(progress_bar.max_value)

var fp_stamina: int:
	set(value):
		progress_bar.value = value
		
		percentage_label.text = "%d%%" % (progress_bar.ratio * 100)
		percentage_label.visible = value < fp_max_stamina
		
	get():
		return int(progress_bar.value)

func init(_fp_fps: int, _key_text: String, params: Dictionary[StringName, Variant]) -> void:
	fp_fps = _fp_fps
	key_text = _key_text
	
	for key: StringName in params:
		if key in self:
			self[key] = params[key]
	
	progress_bar.min_value = 0
	progress_bar.value = fp_max_stamina
