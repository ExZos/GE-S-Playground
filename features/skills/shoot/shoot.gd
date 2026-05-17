extends CooldownSkill

class_name ShootSkill

@export var projectile: ProjectileData

func advance_frame(source: Player, _input_mask: int, just_pressed_mask: int, _just_released_mask: int, dir: Vector2i) -> void:
	if fp_cd_ticks > 0:
		return
	
	if not just_pressed_mask & key_bit or dir == Vector2i.ZERO:
		return
	
	source._projectile_request = ProjectileRequest.new(
		source,
		projectile,
		source.fixed_position_x + (dir.x * source._fp_half_width),
		source.fixed_position_y + (dir.y * source._fp_half_width),
		dir
	)
	
	source.fp_recovery_ticks = _fp_recovery
	fp_cd_ticks = _fp_cooldown

func process_tickers() -> void:
	if fp_cd_ticks > 0:
		fp_cd_ticks -= SGFixed.ONE
