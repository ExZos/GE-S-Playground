extends ChargeSkill

class_name TelekinesisSkill

class VelocityModifier extends ProjectileModifier:
	var source: SGFixedNode2D
	var skill: TelekinesisSkill
	var dir: Vector2i
	
	var applied: bool = false
	
	func _init(_source: SGFixedNode2D, _skill: TelekinesisSkill, _dir: Vector2i) -> void:
		source = _source
		skill = _skill
		dir = _dir
	
	func apply_modification(projectiles: Array) -> void:
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

func _on_activate(dir: Vector2i) -> void:
	print("ACTIVATE")
	
	source._projectile_modifiers.append(VelocityModifier.new(
		source,
		self,
		dir
	))
	
func _on_whiff() -> void:
	print("WHIFF")
	
	fp_cd_ticks = 0
	state = State.IDLE
