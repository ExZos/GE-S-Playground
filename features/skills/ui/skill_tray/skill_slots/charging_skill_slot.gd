extends Control

class_name ChargeSkillSlot

@onready var cooldown_progress_bar: TextureProgressBar = $CooldownProgressBar
@onready var charge_progress_bar: TextureProgressBar = $ChargeProgressBar
@onready var key_label: Label = $Key
@onready var progress_label: Label = $Progress

@export var skill: ChargingSkill

var key_text: String
var fp_fps: float

var last_state: int

func _ready() -> void:
	cooldown_progress_bar.min_value = 0
	cooldown_progress_bar.max_value = skill._fp_cooldown
	cooldown_progress_bar.visible = false
	
	charge_progress_bar.min_value = 0
	charge_progress_bar.max_value = skill._fp_charge_time
	
	key_label.text = key_text
	
	last_state = skill.state

func _process(_delta: float) -> void:
	# Determine cooldown/charging time
	if skill.state == ChargingSkill.State.COOLDOWN:
		cooldown_progress_bar.value = skill.fp_cd_ticks
		progress_label.text = "%.1fs" % (skill.fp_cd_ticks / fp_fps)
	elif skill.state == ChargingSkill.State.CHARGING:
		charge_progress_bar.value = skill.fp_charge_ticks
		progress_label.text = "%d%%" % (charge_progress_bar.ratio * 100)
	
	# Show cooldown/charging progress bar depending on state
	if last_state != skill.state:
		if skill.state == ChargingSkill.State.COOLDOWN:
			charge_progress_bar.visible = false
			cooldown_progress_bar.visible = true
		else:
			charge_progress_bar.visible = true
			cooldown_progress_bar.visible = false
			
			if skill.state == ChargingSkill.State.IDLE:
				charge_progress_bar.value = 0
				cooldown_progress_bar.value = 0
				progress_label.text = ""
				
		last_state = skill.state
