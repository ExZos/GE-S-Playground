extends Skill

class_name CooldownSkill

signal charges_changed(charges: int)

@export var cooldown: int
var _fp_cooldown: int

@export var recovery: int
var _fp_recovery: int

# TODO: here, figure out how this works with charges
@export var duration: int
var _fp_duration: int

@export var max_charges: int = 1
@export var starting_charges: int = 1

var cooling_down: bool = false
var fp_cd_ticks: int = 0
var fp_duration_ticks: int = 0
var charges: int:
	set(value):
		if charges != value:
			charges = value
			charges_changed.emit(value)

func _ready() -> void:
	_fp_cooldown = SGFixed.from_int(cooldown)
	_fp_recovery = SGFixed.from_int(recovery)
	_fp_duration = SGFixed.from_int(duration)
	
	charges = starting_charges

func advance_frame(_input_mask: int, just_pressed_mask: int, _just_released_mask: int, mov_dir: Vector2i, aim_dir: Vector2i) -> void:
	if not (just_pressed_mask & key_bit) or (mov_dir == Vector2i.ZERO and aim_dir == Vector2i.ZERO): # Not pressed or no direction
		return
	elif charges <= 0:
		charges = 0
		return
	
	_on_activate(mov_dir, aim_dir)
	
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

func _on_activate(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void: pass
