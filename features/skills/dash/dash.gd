extends CooldownSkill

# TODO: lock player into moving in movement direction
class_name DashSkill

class DashModifier extends PlayerModifier:
	func apply_and_check() -> bool:
		source.fp_speed_mult += SGFixed.ONE
		
		return super()

func _on_activate(mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	print("DASH: ", mov_dir)
	
	source._player_modifiers.append(DashModifier.new(
		source,
		_fp_duration
	))
