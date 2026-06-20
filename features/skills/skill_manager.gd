extends Node

class_name SkillManager

var _source: SGFixedNode2D

var _attack: Skill
var _skills: Array[Skill] = []

func init(source: SGFixedNode2D, attack_type: StringName, skill_types: Array[StringName]) -> void:
	_source = source
	
	# Initialize basic attack
	if attack_type != null:
		var skill_data: SkillData = RegistryManager.get_skill_data(attack_type)
		if skill_data:
			_attack = skill_data.scene.instantiate()
			_attack.init(source, InputConstants.BitGroup.ATK, skill_data, true)
			
			add_child(_attack)
		else:
			push_warning("SkillManager: Skill type '%s' not recognized" % attack_type)
	
	# Initialize skills
	for i in range(skill_types.size()):
		var skill_data: SkillData = RegistryManager.get_skill_data(skill_types[i])
		if not skill_data:
			push_warning("SkillManager: Skill type '%s' not recognized" % skill_types[i])
			continue
		
		var skill: Skill = skill_data.scene.instantiate()
		skill.init(source, InputConstants.BitList.SKILLS[i], skill_data)
		
		add_child(skill)
		_skills.append(skill)

func advance_frame(input_mask: int, _just_pressed_mask: int, _just_released_mask: int, _mov_dir: Vector2i) -> void:
	# Determine skill direction using held attack direction or movement direction otherwise
	var skill_dir: Vector2i = Vector2i.ZERO
	if input_mask & InputConstants.Bit.ATK_UP: skill_dir = Vector2i.UP
	elif input_mask & InputConstants.Bit.ATK_DOWN: skill_dir = Vector2i.DOWN
	elif input_mask & InputConstants.Bit.ATK_LEFT: skill_dir = Vector2i.LEFT
	elif input_mask & InputConstants.Bit.ATK_RIGHT: skill_dir = Vector2i.RIGHT
	elif input_mask & InputConstants.Bit.MOVE_UP: skill_dir = Vector2i.UP
	elif input_mask & InputConstants.Bit.MOVE_DOWN: skill_dir = Vector2i.DOWN
	elif input_mask & InputConstants.Bit.MOVE_LEFT: skill_dir = Vector2i.LEFT
	elif input_mask & InputConstants.Bit.MOVE_RIGHT: skill_dir = Vector2i.RIGHT
	
	# Skill activation
	for skill: Skill in _skills:
		skill.advance_frame(input_mask, _just_pressed_mask, _just_released_mask, _mov_dir, skill_dir)
	
	# Determine attack direction
	var atk_dir: Vector2i = Vector2i.ZERO
	if _just_pressed_mask & InputConstants.Bit.ATK_UP: atk_dir = Vector2i.UP
	elif _just_pressed_mask & InputConstants.Bit.ATK_DOWN: atk_dir = Vector2i.DOWN
	elif _just_pressed_mask & InputConstants.Bit.ATK_LEFT: atk_dir = Vector2i.LEFT
	elif _just_pressed_mask & InputConstants.Bit.ATK_RIGHT: atk_dir = Vector2i.RIGHT
	
	# Basic attack
	if _attack != null:
		_attack.advance_frame(input_mask, _just_pressed_mask, _just_released_mask, _mov_dir, atk_dir)

func process_tickers() -> void:
	_attack.process_tickers()
	
	for skill: Skill in _skills:
		skill.process_tickers()
