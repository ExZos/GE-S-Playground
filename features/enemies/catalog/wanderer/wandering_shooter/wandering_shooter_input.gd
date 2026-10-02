extends WandererInput

class_name WanderingShooterInput

func get_input_mask(enemy: Enemy, prev_input_mask: int) -> int:
	var input_mask: int = super(enemy, prev_input_mask) & ~InputConstants.BitGroup.ATK
	if not enemy.can_attack():
		return input_mask
	
	var player_pos: SGFixedVector2 = EventBus.get_player_position()
	
	var x_delta: int = enemy.fixed_position_x - player_pos.x
	var y_delta: int = enemy.fixed_position_y - player_pos.y
	
	if absi(x_delta) < absi(y_delta):
		if y_delta > 0:
			input_mask |= InputConstants.Bit.ATK_UP
		else:
			input_mask |= InputConstants.Bit.ATK_DOWN
	else:
		if x_delta > 0:
			input_mask |= InputConstants.Bit.ATK_LEFT
		else:
			input_mask |= InputConstants.Bit.ATK_RIGHT
	
	print("NEW ATTACK: %dms" % SGFixed.to_int(enemy.fp_attack_ticks))
	return input_mask
