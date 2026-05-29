extends CooldownSkill

class_name ShootSkill

@export var projectile_type: ProjectileData.Type

func _on_activate(dir: Vector2i) -> void:
	source._projectile_requests.append(ProjectileRequest.new(
		source,
		projectile_type,
		source.fixed_position_x + (dir.x * source._fp_half_width),
		source.fixed_position_y + (dir.y * source._fp_half_width),
		dir
	))
