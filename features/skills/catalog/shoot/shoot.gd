extends ChargesSkill

class_name ShootSkill

var projectile_type: StringName
var _fp_recovery: int

var _projectile_request: ProjectileRequest

func _process_feature(feature: SkillFeature) -> void:
	match feature.get_feature_type():
		ProjectileFeature.TYPE:
			projectile_type = feature.projectile_type
		
		RecoveryFeature.TYPE:
			_fp_recovery = SGFixed.from_int(feature.recovery)
		
		_: super(feature)

func _ready() -> void:
	_projectile_request = ProjectileRequest.new(
		source,
		projectile_type
	)

func _on_activate(_mov_dir: Vector2i, aim_dir: Vector2i) -> void:
	_projectile_request.set_trajectory(
		source.fixed_position_x + (aim_dir.x * source.fp_half_width),
		source.fixed_position_y + (aim_dir.y * source.fp_half_width),
		aim_dir
	)
	
	source.add_projectile_request(_projectile_request)
	
	source.fp_recovery_ticks = _fp_recovery
