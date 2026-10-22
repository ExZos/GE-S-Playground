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
	
	# Other
	const RESPAWN: int = 1 << 11
	const NEXT_WAVE: int = 1 << 12
	
	# TODO: add diagonals
	const FROM_MOVE_DIR: Dictionary[Vector2i, int] = {
		Vector2i.UP: MOVE_UP,
		Vector2i.DOWN: MOVE_DOWN,
		Vector2i.LEFT: MOVE_LEFT,
		Vector2i.RIGHT: MOVE_RIGHT,
		
		Vector2i.ZERO: 0
	}
	
	const FROM_ATK_DIR: Dictionary[Vector2i, int] = {
		Vector2i.UP: ATK_UP,
		Vector2i.DOWN: ATK_DOWN,
		Vector2i.LEFT: ATK_LEFT,
		Vector2i.RIGHT: ATK_RIGHT,
		
		Vector2i.ZERO: 0
	}

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
	const MOVE: Array[int] = [
		Bit.MOVE_UP,
		Bit.MOVE_UP | Bit.MOVE_RIGHT,
		Bit.MOVE_RIGHT,
		Bit.MOVE_DOWN | Bit.MOVE_RIGHT,
		Bit.MOVE_DOWN,
		Bit.MOVE_DOWN | Bit.MOVE_LEFT,
		Bit.MOVE_LEFT,
		Bit.MOVE_UP | Bit.MOVE_LEFT
	]
	
	const ATK: Array[int] = [
		Bit.ATK_UP,
		Bit.ATK_DOWN,
		Bit.ATK_LEFT,
		Bit.ATK_RIGHT
	]
	
	const SKILLS: Array[int] = [
		Bit.SKILL_1,
		Bit.SKILL_2,
		Bit.SKILL_3
	]

# TODO: rename atk dir
class AtkDirection:
	const FROM_ATK_BIT: Dictionary[int, Vector2i] = {
		Bit.ATK_UP: Vector2i.UP,
		Bit.ATK_DOWN: Vector2i.DOWN,
		Bit.ATK_LEFT: Vector2i.LEFT,
		Bit.ATK_RIGHT: Vector2i.RIGHT,
		
		# 2 inputs x and y
		(Bit.ATK_UP | Bit.ATK_LEFT): Vector2i.UP,
		(Bit.ATK_UP | Bit.ATK_RIGHT): Vector2i.UP,
		(Bit.ATK_DOWN | Bit.ATK_LEFT): Vector2i.DOWN,
		(Bit.ATK_DOWN | Bit.ATK_RIGHT): Vector2i.DOWN,
		
		# 2 inputs opposites
		(Bit.ATK_UP | Bit.ATK_DOWN): Vector2i.UP,
		(Bit.ATK_LEFT | Bit.ATK_RIGHT): Vector2i.LEFT,
		
		# 3 inputs
		(Bit.ATK_UP | Bit.ATK_DOWN | Bit.ATK_LEFT): Vector2i.LEFT,
		(Bit.ATK_UP | Bit.ATK_DOWN | Bit.ATK_RIGHT): Vector2i.RIGHT,
		(Bit.ATK_UP | Bit.ATK_LEFT | Bit.ATK_RIGHT): Vector2i.UP,
		(Bit.ATK_DOWN | Bit.ATK_LEFT | Bit.ATK_RIGHT): Vector2i.DOWN,
		
		# 4 inputs
		(Bit.ATK_UP | Bit.ATK_DOWN | Bit.ATK_LEFT | Bit.ATK_RIGHT): Vector2i.UP
	}
	
	const FROM_MOVE_BIT: Dictionary[int, Vector2i] = {
		Bit.MOVE_UP: Vector2i.UP,
		Bit.MOVE_DOWN: Vector2i.DOWN,
		Bit.MOVE_LEFT: Vector2i.LEFT,
		Bit.MOVE_RIGHT: Vector2i.RIGHT,
		
		# 2 inputs x and y
		(Bit.MOVE_UP | Bit.MOVE_LEFT): Vector2i.UP,
		(Bit.MOVE_UP | Bit.MOVE_RIGHT): Vector2i.UP,
		(Bit.MOVE_DOWN | Bit.MOVE_LEFT): Vector2i.DOWN,
		(Bit.MOVE_DOWN | Bit.MOVE_RIGHT): Vector2i.DOWN,
		
		# 2 inputs opposites
		(Bit.MOVE_UP | Bit.MOVE_DOWN): Vector2i.UP,
		(Bit.MOVE_LEFT | Bit.MOVE_RIGHT): Vector2i.LEFT,
		
		# 3 inputs
		(Bit.MOVE_UP | Bit.MOVE_DOWN | Bit.MOVE_LEFT): Vector2i.LEFT,
		(Bit.MOVE_UP | Bit.MOVE_DOWN | Bit.MOVE_RIGHT): Vector2i.RIGHT,
		(Bit.MOVE_UP | Bit.MOVE_LEFT | Bit.MOVE_RIGHT): Vector2i.UP,
		(Bit.ATK_DOWN | Bit.MOVE_LEFT | Bit.MOVE_RIGHT): Vector2i.DOWN,
		
		# 4 inputs
		(Bit.MOVE_UP | Bit.MOVE_DOWN | Bit.MOVE_LEFT | Bit.MOVE_RIGHT): Vector2i.UP
	}

class ActionName:
	const FROM_BIT: Dictionary[int, StringName] = {
		Bit.SKILL_1: &"skill_1",
		Bit.SKILL_2: &"skill_2",
		Bit.SKILL_3: &"skill_3",
		
		Bit.RESPAWN: &"respawn",
		Bit.NEXT_WAVE: &"next_wave"
	}
