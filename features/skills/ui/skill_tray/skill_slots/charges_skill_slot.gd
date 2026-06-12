extends Control

class_name ChargesSkillSlot

@export var progress_bar: TextureProgressBar
@export var key_label: Label
@export var cooldown_label: Label
@export var charges_label: Label

@export var skill: ChargesSkill

var key_text: String

var fp_fps: float

func _ready() -> void:
	progress_bar.min_value = 0
	progress_bar.max_value = skill._fp_cooldown
	progress_bar.value = progress_bar.max_value - skill.fp_cd_ticks
	
	key_label.text = key_text
	charges_label.text = str(skill.charges)
	
	skill.charges_changed.connect(_on_charges_changed)
	if skill.max_charges <= 1:
		charges_label.visible = false

func _process(_delta: float) -> void:
	if skill.cooling_down:
		progress_bar.value = progress_bar.max_value - skill.fp_cd_ticks
		cooldown_label.text = "%.1fs" % (skill.fp_cd_ticks / fp_fps)
	else:
		cooldown_label.text = ""

func _on_charges_changed(charges: int) -> void:
	charges_label.text = str(charges)
