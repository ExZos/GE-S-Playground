extends Skill

class_name SprintSkill

func advance_frame(source: Player, _input_mask: int, pressed_mask: int, released_mask: int, _aim_dir_x: int, _aim_dir_y: int) -> void:
	if pressed_mask & key_bit: source.speed_mult += 1
	elif released_mask & key_bit: source.speed_mult -= 1
