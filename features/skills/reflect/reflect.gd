extends ChargeSkill

class_name ReflectSkill

func advance_frame(_source: Player, input_mask: int, _just_pressed_mask: int, _just_released_mask: int, _dir: Vector2i) -> void:
	if state == State.COOLDOWN:
		return
	
	if state == State.CHARGING:
		# Key not pressed, stop charging or active skill
		if not (input_mask & key_bit):
			if fp_charge_ticks >= _fp_charge_time:
				fp_cd_ticks += _fp_cooldown
				state = State.COOLDOWN
			else:
				state = State.IDLE
			
			fp_charge_ticks = 0
	else:
		# Key pressed, start charging
		if input_mask & key_bit:
			state = State.CHARGING

func process_tickers() -> void:
	if state == State.COOLDOWN:
		if fp_cd_ticks > 0:
			fp_cd_ticks -= SGFixed.ONE
		
		if fp_cd_ticks <= 0:
			fp_cd_ticks = 0
			state = State.IDLE
	elif state == State.CHARGING and fp_charge_ticks < _fp_charge_time:
		fp_charge_ticks += SGFixed.ONE
