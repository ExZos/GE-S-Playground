extends CooldownSkill

class_name ShootSkill

@export var projectile: ProjectileData

func _on_activate(dir: Vector2i) -> void:
	source._projectile_request = ProjectileRequest.new(
		source,
		projectile,
		source.fixed_position_x + (dir.x * source._fp_half_width),
		source.fixed_position_y + (dir.y * source._fp_half_width),
		dir
	)
