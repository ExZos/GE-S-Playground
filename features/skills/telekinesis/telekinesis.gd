extends ChargeSkill

class_name TelekinesisSkill

class VelocityModifier extends ProjectileModifier:
	var dir: Vector2i = Vector2i.ZERO
	
	var applied: bool = false
	
	func apply(projectiles: Array) -> void:
		applied = false
		var neutral_dir: bool = dir == Vector2i.ZERO
		
		for proj: SGFixedNode2D in projectiles:
			if not source == proj.source:
				continue
			
			proj.fp_speed_mult += SGFixed.ONE
			if not neutral_dir:
				proj.dir = dir
			
			applied = true
			source._vfx_events.append(VFXEvent.new(
				VFXData.Type.TELEKINESIS,
				proj.position
			))
	
	func check_applied() -> void:
		if not applied:
			skill._on_whiff()

var _velocity_modifier: VelocityModifier

func _ready() -> void:
	super()
	
	_velocity_modifier = VelocityModifier.new(
		source,
		self
	)

func _on_activate(_mov_dir: Vector2i, aim_dir: Vector2i) -> void:
	print("ACTIVATE")
	
	_velocity_modifier.dir = aim_dir
	
	source._projectile_modifiers.append(_velocity_modifier)
	
func _on_whiff() -> void:
	print("WHIFF")
	
	fp_cd_ticks = 0
	state = State.IDLE
