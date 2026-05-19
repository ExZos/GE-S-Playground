extends CooldownSkill

class_name ShootSkill

@export var projectile: ProjectileData

func advance_frame(source: Player, _input_mask: int, just_pressed_mask: int, _just_released_mask: int, dir: Vector2i) -> void:
	if charges <= 0:
		charges = 0
		return
	elif not just_pressed_mask & key_bit or dir == Vector2i.ZERO:
		return
	
	source._projectile_request = ProjectileRequest.new(
		source,
		projectile,
		source.fixed_position_x + (dir.x * source._fp_half_width),
		source.fixed_position_y + (dir.y * source._fp_half_width),
		dir
	)
	
	charges -= 1
	source.fp_recovery_ticks = _fp_recovery
	if not cooling_down:
		fp_cd_ticks = _fp_cooldown
		cooling_down = true

func process_tickers() -> void:
	if fp_cd_ticks > 0:
		fp_cd_ticks -= SGFixed.ONE
	elif charges < max_charges:
		charges += 1
		
		if charges != max_charges:
			fp_cd_ticks = _fp_cooldown
			cooling_down = true
		else:
			fp_cd_ticks = 0
			cooling_down = false
