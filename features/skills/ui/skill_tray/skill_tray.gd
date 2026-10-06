extends HBoxContainer

@export var charges_skill_slot_scene: PackedScene
@export var stamina_skill_slot_scene: PackedScene
@export var charging_skill_slot_scene: PackedScene

@export var player: Player

var _fps: int

func _ready() -> void:
	_fps = Engine.get_physics_ticks_per_second()
	var fp_fps = SGFixed.from_int(_fps)
	
	var player_skills: Array[Skill] = player.get_skills()
	for skill: Skill in player_skills:
		var skill_slot: Control
		
		if skill is ChargesSkill:
			skill_slot = charges_skill_slot_scene.instantiate()
			skill_slot.fp_fps = fp_fps
		elif skill is StaminaSkill:
			skill_slot = stamina_skill_slot_scene.instantiate()
		elif skill is ChargingSkill:
			skill_slot = charging_skill_slot_scene.instantiate()
			skill_slot.fp_fps = fp_fps
		else:
			push_warning("SkillTray: Skill type not recognized")
			continue
		
		skill_slot.skill = skill
		skill_slot.key_text = InputDisplayUtils.get_key_text("SkillTray", skill.key_bit)
		
		add_child(skill_slot)
