extends StaminaSkill

class_name SprintSkill

func _on_activate(_dir: Vector2i) -> void:
	source.fp_speed_mult += SGFixed.ONE

func _on_deactivate(_dir: Vector2i) -> void:
	source.fp_speed_mult -= SGFixed.ONE

func _on_exhausted(_dir: Vector2i) -> void:
	source.fp_speed_mult -= SGFixed.ONE
	fp_recov_speed_mod += SGFixed.ONE

func _on_exhausted_recovery() -> void:
	fp_recov_speed_mod -= SGFixed.ONE
