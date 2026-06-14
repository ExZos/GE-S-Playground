extends ChargesSkill

class_name DashSkill

# Stats
var _fp_duration: int
var _fp_speed_add_inc: int
var _fp_speed_mult_sum_inc: int
var _fp_speed_mult_prod_inc: int

var _dash_modifiers: Array[DashModifier]

func _process_feature(feature: SkillFeature) -> void:
	match feature.get_feature_type():
		&"speed":
			_fp_duration = SGFixed.from_int(feature.duration)
			_fp_speed_add_inc = SGFixed.from_int(feature.speed_add_inc)
			_fp_speed_mult_sum_inc = SGFixed.from_int(feature.speed_mult_sum_inc)
			_fp_speed_mult_prod_inc = SGFixed.from_float(feature.speed_mult_prod_inc)
		
		_: super(feature)

func _ready() -> void:
	for i in range(max_charges):
		_dash_modifiers.append(DashModifier.new(
			source,
			_fp_speed_add_inc,
			_fp_speed_mult_sum_inc,
			_fp_speed_mult_prod_inc
		))

func _on_activate(mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	var dash_modifier: DashModifier
	
	for mod in _dash_modifiers:
		if not mod.is_active():
			dash_modifier = mod
			break
	
	if not dash_modifier:
		push_warning("No dash modifiers available. Total dash modifiers: %d" % _dash_modifiers.size())
		dash_modifier = DashModifier.new(
			source,
			_fp_speed_add_inc,
			_fp_speed_mult_sum_inc,
			_fp_speed_mult_prod_inc
		)
		_dash_modifiers.append(dash_modifier)
	
	dash_modifier.dir = mov_dir
	dash_modifier._fp_duration_ticks = _fp_duration
	
	source.add_modifier(dash_modifier)
	
	# TODO: figure out a better way to determine an appropriate speed
	source.vfx_events.append(BubbleVFXEvent.new(
		source.position,
		mov_dir,
		-500
	))

class DashModifier extends PlayerModifier:
	var fp_speed_add_inc: int = 0
	var fp_speed_mult_sum_inc: int = 0
	var fp_speed_mult_prod_inc: int = 0
	var dir: Vector2i = Vector2i.ZERO
	
	func _init(_source: SGFixedNode2D, _fp_speed_add_inc: int, _fp_speed_mult_sum_inc: int, _fp_speed_mult_prod_inc: int) -> void:
		super(_source, 0) # Avoid intializing with duration to track actives
		
		fp_speed_add_inc = _fp_speed_add_inc
		fp_speed_mult_sum_inc = _fp_speed_mult_sum_inc
		fp_speed_mult_prod_inc = _fp_speed_mult_prod_inc

	func apply() -> void:
		source.fp_speed_add += fp_speed_add_inc
		source.fp_speed_mult_sum += fp_speed_mult_sum_inc
		source.fp_speed_mult_prod = SGFixed.mul(source.fp_speed_mult_prod, fp_speed_mult_prod_inc)
		source.forced_mov_dir = dir
	
	func is_active() -> bool:
		return _fp_duration_ticks > 0
