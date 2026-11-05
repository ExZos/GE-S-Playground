extends HBoxContainer

class_name SkillTray

@export var charges_skill_slot_scene: PackedScene
@export var stamina_skill_slot_scene: PackedScene
@export var charging_skill_slot_scene: PackedScene

# TODO: consider including skill slot scene in resource
# TODO: rework to work with pure data, without references to gameplay nodes
func init(fps: int, skills: Array[Skill]) -> void:
	var fp_fps: int = SGFixed.from_int(fps)
	
	for s: Skill in skills:
		var skill_slot: Control
		
		if s is ChargesSkill:
			skill_slot = charges_skill_slot_scene.instantiate()
			skill_slot.fp_fps = fp_fps
		elif s is StaminaSkill:
			skill_slot = stamina_skill_slot_scene.instantiate()
		elif s is ChargingSkill:
			skill_slot = charging_skill_slot_scene.instantiate()
			skill_slot.fp_fps = fp_fps
		else:
			push_warning("SkillTray: Skill type not recognized")
			continue
		
		skill_slot.skill = s
		skill_slot.key_text = InputDisplayUtils.get_key_text("SkillTray", s.key_bit)
		
		add_child(skill_slot)
