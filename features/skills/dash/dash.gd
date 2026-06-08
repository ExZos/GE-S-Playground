extends CooldownSkill

class_name DashSkill

@export var duration: int
var _fp_duration: int

@export var speed_mult_inc: int
var _fp_speed_mult_inc: int

var _dash_modifiers: Array[DashModifier]

func _ready() -> void:
	super()
	
	_fp_duration = SGFixed.from_int(duration)
	_fp_speed_mult_inc = SGFixed.from_int(speed_mult_inc)
	
	for i in range(max_charges):
		_dash_modifiers.append(DashModifier.new(
			source,
			_fp_speed_mult_inc
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
			_fp_speed_mult_inc
		)
		_dash_modifiers.append(dash_modifier)
	
	dash_modifier.dir = mov_dir
	dash_modifier._fp_duration_ticks = _fp_duration
	
	source.add_modifier(dash_modifier)

class DashModifier extends PlayerModifier:
	var fp_speed_mult_inc: int = 0
	var dir: Vector2i = Vector2i.ZERO
	
	func _init(_source: SGFixedNode2D, _fp_speed_mult_inc: int) -> void:
		super(_source, 0) # Avoid intializing with duration for tracking actives
		
		fp_speed_mult_inc = _fp_speed_mult_inc

	func apply() -> void:
		source.fp_speed_mult += fp_speed_mult_inc
		source.forced_mov_dir = dir
	
	func is_active() -> bool:
		return _fp_duration_ticks > 0
