extends CooldownSkill

class_name ShootSkill

@export var projectile_type: ProjectileData.Type

func _on_activate(_mov_dir: Vector2i, aim_dir: Vector2i) -> void:
	source._projectile_requests.append(ProjectileRequest.new(
		source,
		projectile_type,
		source.fixed_position_x + (aim_dir.x * source._fp_half_width),
		source.fixed_position_y + (aim_dir.y * source._fp_half_width),
		aim_dir
	))
