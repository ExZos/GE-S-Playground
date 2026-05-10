extends Skill

class_name SprintSkill

@export var max_stamina: int

var stamina: int
var sprinting: bool = false
var exhausted: bool = false

func _ready() -> void:
	stamina = max_stamina

func advance_frame(source: Player, input_mask: int, _just_pressed_mask: int, _just_released_mask: int, _dir: Vector2i) -> void:
	if exhausted: # Exhausted, prevent sprinting until stamina fully recovered
		if stamina < max_stamina:
			stamina += 1
			print("STAMINA: ", stamina)
		else:
			exhausted = false
	elif sprinting:
		if stamina > 0:
			stamina -= 1
			print("STAMINA: ", stamina)
		
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
		if stamina < max_stamina:
			stamina += 1
			print("STAMINA: ", stamina)
		
		# Key pressed, start sprinting
		if input_mask & key_bit:
			sprinting = true
			source.speed_mult += 1
