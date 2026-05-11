extends StaminaSkill

class_name SprintSkill

var sprinting: bool = false
var exhausted: bool = false

func _ready() -> void:
	stamina = max_stamina

func advance_frame(source: Player, input_mask: int, _just_pressed_mask: int, _just_released_mask: int, _dir: Vector2i) -> void:
	if exhausted: # Exhausted, prevent sprinting
		return
	
	if sprinting:
		# Key not pressed, stop sprinting
		if not (input_mask & key_bit):
			source.speed_mult -= 1
			sprinting = false
		# Stamina depleted, set exhausted state
		elif stamina <= 0:
			source.speed_mult -= 1
			sprinting = false
			exhausted = true
	else:
		# Key pressed, start sprinting
		if input_mask & key_bit:
			sprinting = true
			source.speed_mult += 1

func process_tickers() -> void:
	if sprinting:
		if stamina > 0:
			stamina -= 1
	else:
		if stamina < max_stamina:
			stamina += 1
		elif exhausted:
			exhausted = false
