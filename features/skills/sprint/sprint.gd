extends StaminaSkill

class_name SprintSkill

class SprintModifier extends PlayerModifier:
	func apply_and_check() -> bool:
		source.fp_speed_mult += SGFixed.ONE
		
		return true

var _sprint_modifier: SprintModifier

func _ready() -> void:
	super()
	
	_sprint_modifier = SprintModifier.new(
		source,
		1
	)

func _on_activate(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	source._player_modifiers.append(_sprint_modifier)

func _on_deactivate(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	source._player_modifiers.erase(_sprint_modifier)

func _on_exhausted(_mov_dir: Vector2i, _aim_dir: Vector2i) -> void:
	source._player_modifiers.erase(_sprint_modifier)
	fp_recov_speed_mod += SGFixed.ONE

func _on_exhausted_recovery() -> void:
	fp_recov_speed_mod -= SGFixed.ONE
