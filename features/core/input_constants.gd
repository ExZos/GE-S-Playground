class_name InputConstants

# Bit position for input actions
class Bit:
	# Movement
	const MOVE_UP: int = 1 << 0
	const MOVE_DOWN: int = 1 << 1
	const MOVE_LEFT: int = 1 << 2
	const MOVE_RIGHT: int = 1 << 3

	# Shooting
	const SHOOT_UP: int = 1 << 4
	const SHOOT_DOWN: int = 1 << 5
	const SHOOT_LEFT: int = 1 << 6
	const SHOOT_RIGHT: int = 1 << 7

	const SPRINT: int = 1 << 8
	
	const EQUIP_1: int = 1 << 9
	const EQUIP_2: int = 1 << 10

# Bit position groupings
class BitGroup:
	const MOVE_Y: int = Bit.MOVE_UP | Bit.MOVE_DOWN
	const MOVE_X: int = Bit.MOVE_LEFT | Bit.MOVE_RIGHT
	const MOVE: int = MOVE_Y | MOVE_X
