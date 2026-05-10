extends Skill

class_name ShootSkill

@export var projectile: ProjectileData

func advance_frame(source: Player, _input_mask: int, just_pressed_mask: int, _just_released_mask: int, dir: Vector2i) -> void:
	if cd_ticks > 0:
		cd_ticks -= 1
		return
	
	if not just_pressed_mask & key_bit or dir == Vector2i.ZERO:
		return
	
	source._projectile_request = ProjectileRequest.new(
		source,
		projectile,
		source.fixed_position_x + (dir.x * source._fixed_radius),
		source.fixed_position_y + (dir.y * source._fixed_radius),
		dir
	)
	
	source.recovery_ticks = projectile.recovery_ticks
	cd_ticks = projectile.cooldown_ticks
