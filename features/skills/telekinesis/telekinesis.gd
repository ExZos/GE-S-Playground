extends ChargeSkill

class_name TelekinesisSkill

func _on_activate(_dir: Vector2i) -> void:
	print("ACTIVATE")

func _on_charging_start(_dir: Vector2i) -> void:
	print("CHARGING START")

func _on_charging_cancelled(_dir: Vector2i) -> void:
	print("CHARGING CANCELLED")
