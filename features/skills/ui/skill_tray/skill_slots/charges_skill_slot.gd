extends Control

class_name ChargesSkillSlot

@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@onready var key_label: Label = $Key
@onready var cooldown_label: Label = $Cooldown
@onready var charges_label: Label = $Charges

@export var skill: ChargesSkill

var key_text: String
var fp_fps: float

var last_charges: int

func _ready() -> void:
	progress_bar.min_value = 0
	progress_bar.max_value = skill._fp_cooldown
	
	key_label.text = key_text
	charges_label.text = str(skill.charges)
	
	last_charges = skill.charges
	
	if skill.max_charges <= 1:
		charges_label.visible = false

func _process(_delta: float) -> void:
	if skill.cooling_down:
		progress_bar.value = skill.fp_cd_ticks
		cooldown_label.text = "%.1fs" % (skill.fp_cd_ticks / fp_fps)
	else:
		cooldown_label.text = ""
	
	if last_charges != skill.charges:
		charges_label.text = str(skill.charges)
		last_charges = skill.charges
