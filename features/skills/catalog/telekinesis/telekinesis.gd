extends ChargingSkill

class_name TelekinesisSkill

# Stats that affect player
var _fp_player_speed_mult_prod_inc: int
var _restrict_attack: bool
var _restrict_skills: bool

# Stats that affect projectile
var _fp_projectile_speed_add_inc: int
var _fp_projectile_speed_mult_sum_inc: int
var _fp_projectile_speed_mult_prod_inc: int

var _charging_speed_modifier: ChargingSpeedModifier
var _velocity_modifier: VelocityModifier

func _process_feature(feature: SkillFeature) -> void:
	match feature.get_feature_type():
		ActionRestrictionFeature.TYPE:
			_fp_player_speed_mult_prod_inc = SGFixed.from_float(feature.speed_mult_prod_inc)
			_restrict_attack = feature.restrict_attack
			_restrict_skills = feature.restrict_skills
			
		SpeedFeature.TYPE:
			_fp_projectile_speed_add_inc = SGFixed.from_int(feature.speed_add_inc)
			_fp_projectile_speed_mult_sum_inc = SGFixed.from_int(feature.speed_mult_sum_inc)
			_fp_projectile_speed_mult_prod_inc = SGFixed.from_float(feature.speed_mult_prod_inc)
		
		_: super(feature)

func _ready() -> void:
	_charging_speed_modifier = ChargingSpeedModifier.new(
		source,
		_fp_player_speed_mult_prod_inc,
		_restrict_attack,
		_restrict_skills
	)
	
	_velocity_modifier = VelocityModifier.new(
		source,
		self,
		_fp_projectile_speed_add_inc,
		_fp_projectile_speed_mult_sum_inc,
		_fp_projectile_speed_mult_prod_inc
	)

func _on_charging_start(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	source.add_modifier(_charging_speed_modifier)

func _on_activate(_mov_dir: Vector2i, aim_dir: Vector2i) -> void:
	print("ACTIVATE")
	
	source.remove_modifier(_charging_speed_modifier)
	
	_velocity_modifier.reset(aim_dir)
	EventBus.modify_projectiles(_velocity_modifier)

func _on_charging_cancelled(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	source.remove_modifier(_charging_speed_modifier)

func _on_whiff() -> void:
	print("WHIFF")
	
	fp_cd_ticks = 0
	state = State.IDLE

class ChargingSpeedModifier extends PlayerModifier:
	var fp_speed_mult_prod_inc: int = 0
	var restrict_attack: bool = false
	var restrict_skills: bool = false
	
	func _init(_source: SGFixedNode2D, _fp_speed_mult_prod_inc: int, _restrict_attack: bool, _restrict_skills: bool) -> void:
		super(_source, 0)
		
		fp_speed_mult_prod_inc = _fp_speed_mult_prod_inc
		restrict_attack = _restrict_attack
		restrict_skills = _restrict_skills
	
	func apply() -> void:
		source.fp_speed_mult_prod = SGFixed.mul(source.fp_speed_mult_prod, fp_speed_mult_prod_inc)
		source.restrict_attack = restrict_attack
		source.restrict_skills = restrict_skills
	
	# Keep modifier from being removed
	func tick_and_check() -> bool:
		return true

class VelocityModifier extends ProjectileModifier:
	const VFX_EVENTS_POOL_SIZE: int = 50
	
	var fp_speed_add_inc: int = 0
	var fp_speed_mult_sum_inc: int = 0
	var fp_speed_mult_prod_inc: int = 0
	var dir: Vector2i = Vector2i.ZERO
	
	var _applied: bool = false
	
	var _vfx_events: Array[VFXEvent] = []
	var _vfx_events_count: int = 0
	
	func _init(_source: SGFixedNode2D, _skill: Skill, _fp_speed_add_inc: int, _fp_speed_mult_sum_inc: int, _fp_speed_mult_prod_inc: int) -> void:
		super(_source, _skill)
		
		fp_speed_add_inc = _fp_speed_add_inc
		fp_speed_mult_sum_inc = _fp_speed_mult_sum_inc
		fp_speed_mult_prod_inc = _fp_speed_mult_prod_inc
		
		_vfx_events.resize(VFX_EVENTS_POOL_SIZE)
		for i in range(VFX_EVENTS_POOL_SIZE):
			_vfx_events[i] = BubbleVFXEvent.new(
				Vector2i.ZERO,
				Vector2i.ZERO,
				0
			)
	
	func reset(_dir: Vector2i) -> void:
		dir = _dir
		_applied = false
		_vfx_events_count = 0
	
	func apply(projectiles: Array) -> void:
		var neutral_dir: bool = dir == Vector2i.ZERO
		
		for proj: SGFixedNode2D in projectiles:
			if source != proj.source:
				continue
			
			proj.fp_speed_add += fp_speed_add_inc
			proj.fp_speed_mult_sum += fp_speed_mult_sum_inc
			proj.fp_speed_mult_prod = SGFixed.mul(proj.fp_speed_mult_prod, fp_speed_mult_prod_inc)
			if not neutral_dir:
				proj.dir = dir
			
			_applied = true
			
			if _vfx_events_count < _vfx_events.size():
				_vfx_events[_vfx_events_count].reset(
					proj.position,
					Vector2i.ZERO,
					0
				)
			else:
				push_warning("TelekinesisSkill: No VFX event available, creating one. Total VFX events: %d" % _vfx_events.size())
				_vfx_events.append(BubbleVFXEvent.new(
					proj.position,
					Vector2i.ZERO,
					0
				))
			
			_vfx_events_count += 1
	
	func check_applied() -> void:
		if _applied:
			EventBus.vfx_batch_requested.emit(_vfx_events, _vfx_events_count)
		else:
			skill._on_whiff()
