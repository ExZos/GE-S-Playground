extends Skill

class_name ShootSkill

@export var projectile: ProjectileData

func advance_frame(source: Player, input_mask: int, just_pressed_mask: int, _just_released_mask: int, aim_dir_x: int, aim_dir_y: int) -> void:
	if cd_ticks > 0:
		cd_ticks -= 1
		return
	
	if not just_pressed_mask & key_bit:
		return
	
	source._projectile_request = ProjectileRequest.new(
		source,
		projectile,
		source.fixed_position_x + (aim_dir_x * source._fixed_radius),
		source.fixed_position_y + (aim_dir_y * source._fixed_radius),
		aim_dir_x,
		aim_dir_y
	)
	
	source.recovery_ticks = projectile.recovery_ticks
	cd_ticks = projectile.cooldown_ticks
