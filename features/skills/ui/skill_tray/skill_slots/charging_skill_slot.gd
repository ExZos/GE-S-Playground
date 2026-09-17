extends Control

class_name ChargeSkillSlot

@onready var charge_progress_bar: TextureProgressBar = $MarginContainer/ProgressBarContainer/ChargeProgressBar
@onready var cooldown_progress_bar: TextureProgressBar = $MarginContainer/ProgressBarContainer/CooldownProgressBar
@onready var key_label: Label = $Key
@onready var progress_label: Label = $MarginContainer/Progress

@export var skill: ChargingSkill

var key_text: String
var fp_fps: float

var last_state: int

func _ready() -> void:
	cooldown_progress_bar.min_value = 0
	cooldown_progress_bar.max_value = skill._fp_cooldown
	cooldown_progress_bar.value = skill._fp_cooldown
	
	charge_progress_bar.min_value = 0
	charge_progress_bar.max_value = skill._fp_charge_time
	
	key_label.text = key_text
	
	last_state = skill.state

func _process(_delta: float) -> void:
	# Determine cooldown/charging time
	if skill.state == ChargingSkill.State.COOLDOWN:
		cooldown_progress_bar.value = skill._fp_cooldown - skill.fp_cd_ticks
		progress_label.text = "%.1fs" % (skill.fp_cd_ticks / fp_fps)
	elif skill.state == ChargingSkill.State.CHARGING:
		charge_progress_bar.value = skill.fp_charge_ticks
		progress_label.text = "%d%%" % (charge_progress_bar.ratio * 100)
	
	if last_state != skill.state:
		if skill.state == ChargingSkill.State.COOLDOWN:
			cooldown_progress_bar.tint_progress = Color.GRAY
			charge_progress_bar.value = 0
		elif skill.state == ChargingSkill.State.IDLE:
			cooldown_progress_bar.value = skill._fp_cooldown
			cooldown_progress_bar.tint_progress = Color.WHITE
			charge_progress_bar.value = 0
			progress_label.text = ""
		
		last_state = skill.state
