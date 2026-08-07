class_name DamageSystem

static func apply_damage(target: Node, fp_damage: int):
	if not "IS_DAMAGEABLE" in target:
		return
	
	target.fp_current_hp -= fp_damage
	
	if target.fp_current_hp <= 0:
		target.is_dead = true
		
		target.on_death()
