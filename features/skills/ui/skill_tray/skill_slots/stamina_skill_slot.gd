extends Control

class_name StaminaSkillSlot

@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@onready var key_label: Label = $Key
@onready var percentage_label: Label = $Percentage

@export var skill: StaminaSkill

var key_text: String

var last_state: int
var last_value: int

func _ready() -> void:
	progress_bar.min_value = 0
	progress_bar.max_value = skill._fp_max_stamina
	progress_bar.value = skill.fp_stamina
	
	key_label.text = key_text
	
	last_state = skill.state

func _process(_delta: float) -> void:
	if last_value != skill.fp_stamina:
		progress_bar.value = skill.fp_stamina
		
		if skill.fp_stamina < progress_bar.max_value:
			percentage_label.text = "%d%%" % (progress_bar.ratio * 100)
		else:
			percentage_label.text = ""
		
		last_value = skill.fp_stamina
	
	if last_state != skill.state:
		if skill.state == StaminaSkill.State.EXHAUSTED:
			progress_bar.tint_progress = Color.GRAY
		else:
			progress_bar.tint_progress = Color.WHITE
		
		last_state = skill.state
