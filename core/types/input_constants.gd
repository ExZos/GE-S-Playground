class_name InputConstants

# Bit position for input actions
class Bit:
	# Movement
	const MOVE_UP: int = 1 << 0
	const MOVE_DOWN: int = 1 << 1
	const MOVE_LEFT: int = 1 << 2
	const MOVE_RIGHT: int = 1 << 3

	# Basic attack
	const ATK_UP: int = 1 << 4
	const ATK_DOWN: int = 1 << 5
	const ATK_LEFT: int = 1 << 6
	const ATK_RIGHT: int = 1 << 7
	
	# Skills
	const SKILL_1: int = 1 << 8
	const SKILL_2: int = 1 << 9
	const SKILL_3: int = 1 << 10

# Bit position groupings
class BitGroup:
	# Movement
	const MOVE_Y: int = Bit.MOVE_UP | Bit.MOVE_DOWN
	const MOVE_X: int = Bit.MOVE_LEFT | Bit.MOVE_RIGHT
	const MOVE: int = MOVE_Y | MOVE_X
	
	# Basic attack
	const ATK_Y: int = Bit.ATK_UP | Bit.ATK_DOWN
	const ATK_X: int = Bit.ATK_LEFT | Bit.ATK_RIGHT
	const ATK: int = ATK_Y | ATK_X
	
# 
class BitList:
	const SKILLS: Array[int] = [
		Bit.SKILL_1,
		Bit.SKILL_2,
		Bit.SKILL_3
	]

class ActionName:
	const FROM_BIT: Dictionary[int, StringName] = {
		Bit.SKILL_1: &"skill_1",
		Bit.SKILL_2: &"skill_2",
		Bit.SKILL_3: &"skill_3"
	}
