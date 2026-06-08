extends ChargeSkill

class_name TelekinesisSkill

@export var speed_mult_inc: int = 0
var _fp_speed_mult_inc: int

var _velocity_modifier: VelocityModifier

func _ready() -> void:
	super()
	
	_fp_speed_mult_inc = SGFixed.from_int(speed_mult_inc)
	
	_velocity_modifier = VelocityModifier.new(
		source,
		self,
		_fp_speed_mult_inc
	)

func _on_activate(_mov_dir: Vector2i, aim_dir: Vector2i) -> void:
	print("ACTIVATE")
	
	_velocity_modifier.dir = aim_dir
	
	source.projectile_modifiers.append(_velocity_modifier)
	
func _on_whiff() -> void:
	print("WHIFF")
	
	fp_cd_ticks = 0
	state = State.IDLE

class VelocityModifier extends ProjectileModifier:
	var fp_speed_mult_inc: int = 0
	var dir: Vector2i = Vector2i.ZERO
	
	var applied: bool = false
	
	func _init(_source: SGFixedNode2D, _skill: Skill, _fp_speed_mult_inc: int) -> void:
		super(_source, _skill)
		
		fp_speed_mult_inc = _fp_speed_mult_inc
	
	func apply(projectiles: Array) -> void:
		applied = false
		var neutral_dir: bool = dir == Vector2i.ZERO
		
		for proj: SGFixedNode2D in projectiles:
			if not source == proj.source:
				continue
			
			proj.fp_speed_mult += fp_speed_mult_inc
			if not neutral_dir:
				proj.dir = dir
			
			applied = true
			source.vfx_events.append(VFXEvent.new(
				VFXData.Type.TELEKINESIS,
				proj.position
			))
	
	func check_applied() -> void:
		if not applied:
			skill._on_whiff()
