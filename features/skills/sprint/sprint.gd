extends Skill

class_name SprintSkill

var activated: bool = false

func advance_frame(source: Player, input_mask: int, _just_pressed_mask: int, _just_released_mask: int, _dir: Vector2i) -> void:
	if (input_mask & key_bit) and not activated:
		activated = true
		source.speed_mult += 1
	elif not (input_mask & key_bit) and activated:
		source.speed_mult -= 1
		activated = false
