extends Control

class_name ChargeSkillSlot

@onready var charge_progress_bar: TextureProgressBar = $MarginContainer/ProgressBarContainer/ChargeProgressBar
@onready var cooldown_progress_bar: TextureProgressBar = $MarginContainer/ProgressBarContainer/CooldownProgressBar
@onready var key_label: Label = $Key
@onready var progress_label: Label = $MarginContainer/Progress

var fp_fps: float

var key_text: String:
	set(value):
		key_label.text = value
	
	get():
		return key_label.text

var state: ChargingSkill.State:
	set(value):
		state = value
		
		if value == ChargingSkill.State.CHARGING:
			cooldown_progress_bar.tint_progress = Color.WHITE
			progress_label.visible = true
		elif value == ChargingSkill.State.COOLDOWN:
			cooldown_progress_bar.tint_progress = Color.GRAY
			progress_label.visible = true
		else: # value == ChargingSkill.State.IDLE:
			cooldown_progress_bar.tint_progress = Color.WHITE
			progress_label.visible = false

var fp_cooldown: int:
	set(value):
		cooldown_progress_bar.max_value = value
	
	get():
		return int(cooldown_progress_bar.max_value)

var fp_cd_ticks: int:
	set(value):
		cooldown_progress_bar.value = fp_cooldown - value
		progress_label.text = "%.1fs" % (value / fp_fps)
	
	get():
		return int(fp_cooldown - cooldown_progress_bar.value)

var fp_charge_time: int:
	set(value):
		charge_progress_bar.max_value = value
	
	get():
		return int(charge_progress_bar.max_value)

var fp_charge_ticks: int:
	set(value):
		charge_progress_bar.value = value
		progress_label.text = "%d%%" % (charge_progress_bar.ratio * 100)
	
	get():
		return int(charge_progress_bar.value)

func init(_fp_fps: int, _key_text: String, params: Dictionary[StringName, Variant]) -> void:
	fp_fps = _fp_fps
	key_text = _key_text
	
	for key: StringName in params:
		if key in self:
			self[key] = params[key]
	
	cooldown_progress_bar.min_value = 0
	charge_progress_bar.min_value = 0
