extends Skill

class_name ChargesSkill

signal charges_changed(charges: int)

var cooling_down: bool = false

# Stats
var _fp_cooldown: int
var max_charges: int
var charges_inc: int

# Tickers
var fp_cd_ticks: int = 0
var charges: int:
	set(value):
		if charges != value:
			charges = value
			charges_changed.emit(value)

func _process_feature(feature: SkillFeature) -> void:
	match feature.get_feature_type():
		&"charges":
			max_charges = feature.max_charges
			charges = feature.starting_charges
			charges_inc = feature.charges_inc
		
		&"cooldown":
			_fp_cooldown = SGFixed.from_int(feature.cooldown)
		
		_: super(feature)

func advance_frame(_input_mask: int, just_pressed_mask: int, _just_released_mask: int, mov_dir: Vector2i, aim_dir: Vector2i) -> void:
	if not (just_pressed_mask & key_bit) or (mov_dir == Vector2i.ZERO and aim_dir == Vector2i.ZERO): # Not pressed or no direction
		return
	elif charges <= 0:
		charges = 0
		return
	
	_on_activate(mov_dir, aim_dir)
	
	charges -= 1
	if not cooling_down:
		fp_cd_ticks = _fp_cooldown
		cooling_down = true

func process_tickers() -> void:
	if fp_cd_ticks > 0:
		fp_cd_ticks -= SGFixed.ONE
	elif charges < max_charges:
		charges = min(max_charges, charges + charges_inc)
		
		if charges != max_charges:
			fp_cd_ticks = _fp_cooldown
			cooling_down = true
		else:
			fp_cd_ticks = 0
			cooling_down = false

func _on_activate(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void: pass
