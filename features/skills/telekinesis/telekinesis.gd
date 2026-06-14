extends ChargingSkill

class_name TelekinesisSkill

# Stats
var _fp_speed_add_inc: int
var _fp_speed_mult_sum_inc: int
var _fp_speed_mult_prod_inc: int

var _velocity_modifier: VelocityModifier

func _process_feature(feature: SkillFeature) -> void:
	match feature.get_feature_type():
		&"speed":
			_fp_speed_add_inc = SGFixed.from_int(feature.speed_add_inc)
			_fp_speed_mult_sum_inc = SGFixed.from_int(feature.speed_mult_sum_inc)
			_fp_speed_mult_prod_inc = SGFixed.from_int(feature.speed_mult_prod_inc)
		
		_: super(feature)

func _ready() -> void:
	_velocity_modifier = VelocityModifier.new(
		source,
		self,
		_fp_speed_add_inc,
		_fp_speed_mult_sum_inc,
		_fp_speed_mult_prod_inc
	)

func _on_activate(_mov_dir: Vector2i, aim_dir: Vector2i) -> void:
	print("ACTIVATE")
	
	_velocity_modifier.dir = aim_dir
	_velocity_modifier.applied = false
	
	source.projectile_modifiers.append(_velocity_modifier)

func _on_whiff() -> void:
	print("WHIFF")
	
	fp_cd_ticks = 0
	state = State.IDLE

class VelocityModifier extends ProjectileModifier:
	var fp_speed_add_inc: int = 0
	var fp_speed_mult_sum_inc: int = 0
	var fp_speed_mult_prod_inc: int = 0
	var dir: Vector2i = Vector2i.ZERO
	
	var applied: bool = false
	
	func _init(_source: SGFixedNode2D, _skill: Skill, _fp_speed_add_inc: int, _fp_speed_mult_sum_inc: int, _fp_speed_mult_prod_inc: int) -> void:
		super(_source, _skill)
		
		fp_speed_add_inc = _fp_speed_add_inc
		fp_speed_mult_sum_inc = _fp_speed_mult_sum_inc
		fp_speed_mult_prod_inc = _fp_speed_mult_prod_inc
	
	func apply(projectiles: Array) -> void:
		var neutral_dir: bool = dir == Vector2i.ZERO
		
		for proj: SGFixedNode2D in projectiles:
			if not source == proj.source:
				continue
			
			proj.fp_speed_add += fp_speed_add_inc
			proj.fp_speed_mult_sum += fp_speed_mult_sum_inc
			proj.fp_speed_mult_prod = SGFixed.mul(proj.fp_speed_mult_prod, fp_speed_mult_prod_inc)
			if not neutral_dir:
				proj.dir = dir
			
			applied = true
			source.vfx_events.append(BubbleVFXEvent.new(
				proj.position,
				Vector2i.ZERO,
				0
			))
	
	func check_applied() -> void:
		if not applied:
			skill._on_whiff()
