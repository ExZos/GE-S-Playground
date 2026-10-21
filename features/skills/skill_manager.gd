extends Node

class_name SkillManager

var _source: Character

var _attack: Skill
var _skills: Array[Skill] = []

var _last_mov_input: int
var _last_mov_dir: Vector2i

func init(source: Character, attack_type: StringName, skill_types: Array[StringName]) -> void:
	_source = source
	
	# Initialize basic attack
	if attack_type:
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
	
	_last_mov_input = 0
	_last_mov_dir = Vector2i.ZERO

func advance_frame(input_mask: int, _just_pressed_mask: int, _just_released_mask: int, _mov_dir: Vector2i, atk_dir) -> void:
	# TODO: alter logic if skill direction uses player direction (telekinesis neutral dir activation)
	# Determine skill direction using held attack direction or movement direction otherwise
	var skill_dir: Vector2i = Vector2i.ZERO
	if atk_dir != Vector2i.ZERO: skill_dir = atk_dir
	elif input_mask & InputConstants.BitGroup.MOVE != 0:
		if _just_pressed_mask & InputConstants.BitGroup.MOVE != 0:
			_last_mov_dir = InputConstants.ATK_Direction.FROM_MOVE_BIT[_just_pressed_mask & InputConstants.BitGroup.MOVE]
			_last_mov_input = InputConstants.Bit.FROM_MOVE_DIR[_last_mov_dir]
		elif _just_released_mask & _last_mov_input:
			if input_mask & InputConstants.BitGroup.MOVE != 0:
				_last_mov_dir = InputConstants.ATK_Direction.FROM_MOVE_BIT[input_mask & InputConstants.BitGroup.MOVE]
				_last_mov_input = InputConstants.Bit.FROM_MOVE_DIR[_last_mov_dir]
			else:
				_last_mov_dir = Vector2i.ZERO
				_last_mov_input = 0
				
		skill_dir = _last_mov_dir
	
	# Skill activation
	for skill: Skill in _skills:
		skill.advance_frame(input_mask, _just_pressed_mask, _just_released_mask, _mov_dir, skill_dir)
	
	# Basic attack
	if _attack != null:
		_attack.advance_frame(input_mask, _just_pressed_mask, _just_released_mask, _mov_dir, atk_dir)

func process_tickers() -> void:
	if _attack:
		_attack.process_tickers()
	
	for skill: Skill in _skills:
		skill.process_tickers()
