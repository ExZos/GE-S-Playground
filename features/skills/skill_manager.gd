extends Node

class_name SkillManager

@export var skill_registry: SkillRegistry

var _source: SGFixedNode2D

var _basic_attack: Skill
var _skills: Array[Skill] = []

func init(source: SGFixedNode2D, basic_attack_type: SkillData.Type, skill_types: Array[SkillData.Type]) -> void:
	_source = source
	
	skill_registry.init()
	
	# Initialize basic attack
	if basic_attack_type != null:
		var skill_data: SkillData = skill_registry.get_data(basic_attack_type)
		if skill_data:
			_basic_attack = skill_data.scene.instantiate()
			
			_basic_attack.source = source
			_basic_attack.key_bit = InputConstants.BitGroup.ATK
			
			add_child(_basic_attack)
		else:
			push_warning("SkillManager: Skill type '%s' not recognized" % basic_attack_type)
	
	# Initialize skills
	for i in range(skill_types.size()):
		var skill_data: SkillData = skill_registry.get_data(skill_types[i])
		if not skill_data:
			push_warning("SkillManager: Skill type '%s' not recognized" % skill_types[i])
			continue
		
		var skill: Skill = skill_data.scene.instantiate()
		
		skill.source = source
		skill.key_bit = InputConstants.BitList.SKILLS[i]
		
		add_child(skill)
		_skills.append(skill)

func advance_frame(input_mask: int, _just_pressed_mask: int, _just_released_mask: int) -> void:
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
		skill.advance_frame(input_mask, _just_pressed_mask, _just_released_mask, skill_dir)
	
	# Determine attack direction
	var atk_dir: Vector2i = Vector2i.ZERO
	if _just_pressed_mask & InputConstants.Bit.ATK_UP: atk_dir = Vector2i.UP
	elif _just_pressed_mask & InputConstants.Bit.ATK_DOWN: atk_dir = Vector2i.DOWN
	elif _just_pressed_mask & InputConstants.Bit.ATK_LEFT: atk_dir = Vector2i.LEFT
	elif _just_pressed_mask & InputConstants.Bit.ATK_RIGHT: atk_dir = Vector2i.RIGHT
	
	# Basic attack
	if _basic_attack != null:
		_basic_attack.advance_frame(input_mask, _just_pressed_mask, _just_released_mask, atk_dir)

func process_tickers() -> void:
	_basic_attack.process_tickers()
	
	for skill: Skill in _skills:
		skill.process_tickers()
