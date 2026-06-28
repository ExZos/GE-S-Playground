extends Control

class_name StaminaSkillSlot

@export var progress_bar: TextureProgressBar
@export var key_label: Label
@export var percentage_label: Label

@export var skill: StaminaSkill

var key_text: String

func _ready() -> void:
	progress_bar.min_value = 0
	progress_bar.max_value = skill._fp_max_stamina
	progress_bar.value = skill.fp_stamina
	
	key_label.text = key_text
	
	skill.state_changed.connect(_on_state_changed)

func _process(_delta: float) -> void:
	progress_bar.value = skill.fp_stamina
	
	if progress_bar.value < progress_bar.max_value:
		percentage_label.text = "%d%%" % (progress_bar.ratio * 100)
	else:
		percentage_label.text = ""

func _exit_tree() -> void:
	if skill and skill.state_changed.is_connected(_on_state_changed):
		skill.state_changed.disconnect(_on_state_changed)

func _on_state_changed(state: StaminaSkill.State) -> void:
	if skill.state == StaminaSkill.State.EXHAUSTED:
		progress_bar.tint_progress = Color.GRAY
	else:
		progress_bar.tint_progress = Color.WHITE
