extends HBoxContainer

@export var cooldown_skill_slot_scene: PackedScene
@export var stamina_skill_slot_scene: PackedScene

@export var player: Player

func _ready() -> void:
	await player.ready
	
	for skill in player._skills:
		var skill_slot: Control
		
		if skill is CooldownSkill:
			skill_slot = cooldown_skill_slot_scene.instantiate()
		elif skill is StaminaSkill:
			skill_slot = stamina_skill_slot_scene.instantiate()
		else:
			push_error("SkillTray: Skill type not recognized")
			continue
		
		skill_slot.skill = skill
		skill_slot.key_text = _get_key_text(skill.key_bit)
		
		add_child(skill_slot)

func _get_key_text(key_bit: int) -> String:
	var action_name: StringName = InputConstants.ActionName.FROM_BIT[key_bit]
	if not InputMap.has_action(action_name):
		return "?"
		
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	if events.size() == 0:
		return "?"
	
	return events[0].as_text().replace(" - Physical", "")
