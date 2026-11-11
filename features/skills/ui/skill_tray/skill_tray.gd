extends HBoxContainer

class_name SkillTray

@export var charges_skill_slot_scene: PackedScene
@export var stamina_skill_slot_scene: PackedScene
@export var charging_skill_slot_scene: PackedScene

var skills: Array[Skill] # TODO: use an array of skill param dictionaries instead
var skill_slots: Array[Control]
var _last_skill_params: Array[Dictionary]

# TODO: rework with pure data, without references to gameplay nodes
func init(fps: int, _skills: Array[Skill]) -> void:
	var fp_fps: int = SGFixed.from_int(fps)
	skills = _skills
	
	for s: Skill in _skills:
		var skill_slot: Control
		var last_skill_params: Dictionary[StringName, Variant]
		
		if s is ChargesSkill:
			skill_slot = charges_skill_slot_scene.instantiate()
			
			last_skill_params[&"cooling_down"] = s.cooling_down
			last_skill_params[&"fp_cooldown"] = s.fp_cooldown
			last_skill_params[&"fp_cd_ticks"] = s.fp_cd_ticks
			last_skill_params[&"max_charges"] = s.max_charges
			last_skill_params[&"charges"] = s.charges
		elif s is ChargingSkill:
			skill_slot = charging_skill_slot_scene.instantiate()
			
			last_skill_params[&"state"] = s.state
			last_skill_params[&"fp_cooldown"] = s.fp_cooldown
			last_skill_params[&"fp_cd_ticks"] = s.fp_cd_ticks
			last_skill_params[&"fp_charge_time"] = s.fp_charge_time
			last_skill_params[&"fp_charge_ticks"] = s.fp_charge_ticks
		elif s is StaminaSkill:
			skill_slot = stamina_skill_slot_scene.instantiate()
			
			last_skill_params[&"state"] = s.state
			last_skill_params[&"fp_max_stamina"] = s.fp_max_stamina
			last_skill_params[&"fp_stamina"] = s.fp_stamina
		else:
			push_warning("SkillTray: Skill type not recognized")
			continue
		
		add_child(skill_slot)
		
		skill_slot.init(
			fp_fps,
			InputDisplayUtils.get_key_text(name, s.key_bit),
			last_skill_params
		)
		
		skill_slots.append(skill_slot)
		_last_skill_params.append(last_skill_params)

func _process(_delta: float) -> void:
	for i in range(skill_slots.size()):
		var skill_slot: Control = skill_slots[i]
		var skill: Skill = skills[i]
		var last_skill_params: Dictionary[StringName, Variant] = _last_skill_params[i]
		
		for key: StringName in last_skill_params:
			if skill[key] != last_skill_params[key]:
				skill_slot[key] = skill[key]
			
			last_skill_params[key] = skill[key]
