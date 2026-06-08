extends StaminaSkill

class_name SprintSkill

@export var speed_mult_inc: int = 0
var _fp_speed_mult_inc: int

var _sprint_modifier: SprintModifier

func _ready() -> void:
	super()
	
	_fp_speed_mult_inc = SGFixed.from_int(speed_mult_inc)
	
	_sprint_modifier = SprintModifier.new(
		source,
		_fp_speed_mult_inc
	)

func _on_activate(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	source.add_modifier(_sprint_modifier)

func _on_deactivate(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	source.remove_modifier(_sprint_modifier)

func _on_exhausted(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	source.remove_modifier(_sprint_modifier)
	fp_recov_speed_mod += SGFixed.ONE # TODO: add this as a modifier instead

func _on_exhausted_recovery() -> void:
	fp_recov_speed_mod -= SGFixed.ONE

class SprintModifier extends PlayerModifier:
	var fp_speed_mult_inc: int = 0
	
	func _init(_source: SGFixedNode2D, _fp_speed_mult_inc: int) -> void:
		super(_source, 0)
		
		fp_speed_mult_inc = _fp_speed_mult_inc
	
	func apply() -> void:
		source.fp_speed_mult += fp_speed_mult_inc
	
	# Keep modifier from being removed
	func tick_and_check() -> bool:
		return true
