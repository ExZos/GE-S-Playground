extends HBoxContainer

@export var cooldown_skill_slot_scene: PackedScene
@export var stamina_skill_slot_scene: PackedScene

@export var player: Player

var _fps: int

func _ready() -> void:
	_fps = Engine.get_physics_ticks_per_second()
	var float_fps = float(_fps)
	
	await player.ready
	for skill in player._skills:
		var skill_slot: Control
		
		if skill is CooldownSkill:
			skill_slot = cooldown_skill_slot_scene.instantiate()
			skill_slot._float_fps = float_fps
		elif skill is StaminaSkill:
			skill_slot = stamina_skill_slot_scene.instantiate()
		else:
			push_warning("SkillTray: Skill type not recognized")
			continue
		
		skill_slot.skill = skill
		skill_slot.key_text = _get_key_text(skill.key_bit)
		
		add_child(skill_slot)

func _get_key_text(key_bit: int) -> String:
	if not InputConstants.ActionName.FROM_BIT.has(key_bit):
		push_warning("SkillTray: Key bit '%d' not mapped to an action name" % key_bit)
		return "?"
	
	var action_name: StringName = InputConstants.ActionName.FROM_BIT[key_bit]
	if not InputMap.has_action(action_name):
		push_warning("SkillTray: Action name '%s' not recognized" % action_name)
		return "?"
		
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	if events.size() == 0:
		push_warning("SkillTray: Action name '%s' does not any events")
		return "?"
	
	return events[0].as_text_physical_keycode()
