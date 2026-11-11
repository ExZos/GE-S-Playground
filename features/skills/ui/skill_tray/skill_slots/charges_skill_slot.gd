extends Control

class_name ChargesSkillSlot

@onready var progress_bar: TextureProgressBar = $MarginContainer/ProgressBarContainer/TextureProgressBar
@onready var key_label: Label = $Key
@onready var cooldown_label: Label = $MarginContainer/Cooldown
@onready var charges_label: Label = $Charges

var fp_fps: float

var key_text: String:
	set(value):
		key_label.text = value
	
	get():
		return key_label.text

var cooling_down: bool:
	set(value):
		cooldown_label.visible = value
	
	get():
		return cooldown_label.visible

var fp_cooldown: int:
	set(value):
		progress_bar.max_value = value
	
	get():
		return int(progress_bar.max_value)

var fp_cd_ticks: int:
	set(value):
		progress_bar.value = fp_cooldown - value
		cooldown_label.text = "%.1fs" % (value / fp_fps)
	
	get():
		return int(fp_cooldown - progress_bar.value)

var max_charges: int:
	set(value):
		max_charges = value
		charges_label.visible = value > 1

var charges: int:
	set(value):
		charges_label.text = str(value)
		
		if value == 0:
			progress_bar.tint_progress = Color.GRAY
		else:
			progress_bar.tint_progress = Color.WHITE
			
	get():
		return int(charges_label.text)

func init(_fp_fps: int, _key_text: String, params: Dictionary[StringName, Variant]) -> void:
	fp_fps = _fp_fps
	key_text = _key_text
	
	for key: StringName in params:
		if key in self:
			self[key] = params[key]
	
	progress_bar.min_value = 0
	progress_bar.value = fp_cooldown
