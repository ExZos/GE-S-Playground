extends BaseDataRegistry

class_name ProjectileRegistry

@export var projectile_data: Array[ProjectileData]

func _get_resources() -> Array:
	return projectile_data

func get_data(type: StringName) -> ProjectileData:
	return _get_generic_data(type)
