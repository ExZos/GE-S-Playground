extends SGFixedNode2D

class_name Skill

var source: SGFixedNode2D
var key_bit: int

var check_restricted: Callable

func init(_source: SGFixedNode2D, _key_bit: int, data: SkillData, is_attack: bool = false) -> void:
	source = _source
	key_bit = _key_bit
	check_restricted = source.check_restrict_attack if is_attack else source.check_restrict_skills
	
	for feature in data.features:
		_process_feature(feature)

func _process_feature(feature: SkillFeature) -> void:
	match feature.get_feature_type():
		_:
			push_warning("Skill: Feature type '%s' not recognized" % feature.TYPE)

func advance_frame(_input_mask: int, _just_pressed_mask: int, _just_released_mask: int, _mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	pass

func process_tickers() -> void:
	pass
