extends Control

class_name ChargeSkillSlot

@export var cooldown_progress_bar: TextureProgressBar
@export var charge_progress_bar: TextureProgressBar
@export var key_label: Label
@export var progress_label: Label

@export var skill: ChargeSkill

var key_text: String

var fp_fps: float

func _ready() -> void:
	cooldown_progress_bar.min_value = 0
	cooldown_progress_bar.max_value = skill._fp_cooldown
	cooldown_progress_bar.visible = false
	
	charge_progress_bar.min_value = 0
	charge_progress_bar.max_value = skill._fp_charge_time
	
	key_label.text = key_text
	
	skill.state_changed.connect(_on_state_changed)

func _process(_delta: float) -> void:
	if skill.state == ChargeSkill.State.COOLDOWN:
		cooldown_progress_bar.value = cooldown_progress_bar.max_value - skill.fp_cd_ticks
		progress_label.text = "%.1fs" % (skill.fp_cd_ticks / fp_fps)
	elif skill.state == ChargeSkill.State.CHARGING:
		charge_progress_bar.value = skill.fp_charge_ticks
		progress_label.text = "%d%%" % (charge_progress_bar.ratio * 100)
	else:
		progress_label.text = ""

func _on_state_changed(state: ChargeSkill.State) -> void:
	if state == ChargeSkill.State.COOLDOWN:
		charge_progress_bar.visible = false
		cooldown_progress_bar.visible = true
	else:
		charge_progress_bar.visible = true
		cooldown_progress_bar.visible = false
		
		if state == ChargeSkill.State.IDLE:
			cooldown_progress_bar.value = 0
			charge_progress_bar.value = 0
