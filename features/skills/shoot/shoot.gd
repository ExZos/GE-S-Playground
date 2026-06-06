extends CooldownSkill

class_name ShootSkill

@export var projectile_type: ProjectileData.Type

var _projectile_request: ProjectileRequest

func _ready() -> void:
	super()
	
	_projectile_request = ProjectileRequest.new(
		source,
		projectile_type
	)

func _on_activate(_mov_dir: Vector2i, aim_dir: Vector2i) -> void:
	_projectile_request.set_trajectory(
		source.fixed_position_x + (aim_dir.x * source._fp_half_width),
		source.fixed_position_y + (aim_dir.y * source._fp_half_width),
		aim_dir
	)
	
	source.projectile_requests.append(_projectile_request)
