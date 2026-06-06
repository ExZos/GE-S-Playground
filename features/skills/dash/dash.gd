extends CooldownSkill

# TODO: modifier pools equal to charges
class_name DashSkill

@export var speed_mult_add: int = 0

var _fp_speed_mult_add: int

func _ready() -> void:
	super()
	
	_fp_speed_mult_add = SGFixed.from_int(speed_mult_add)

class DashModifier extends PlayerModifier:
	var fp_speed_mult_add: int = 0
	var dir: Vector2i = Vector2i.ZERO
	
	func _init(_source: SGFixedNode2D, _fp_duration: int, _fp_speed_mult_add: int, _dir: Vector2i) -> void:
		super(_source, _fp_duration)
		
		fp_speed_mult_add = _fp_speed_mult_add
		dir = _dir

	func apply() -> void:
		source.fp_speed_mult += fp_speed_mult_add
		source.forced_mov_dir = dir

func _on_activate(mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	source.add_modifier(DashModifier.new(
		source,
		_fp_duration,
		_fp_speed_mult_add,
		mov_dir
	))
