extends BaseRegistry

class_name ProjectileRegistry

@export var projectile_data: Array[ProjectileData]

func init() -> void:
	if is_init:
		return
	
	var resources: Array = _get_resources()
	for res: RegistryData in resources:
		_lookup[res.id] = res
	
	is_init = true

func _get_resources() -> Array:
	return projectile_data

func get_data(type: ProjectileData.Type) -> ProjectileData:
	return _get_generic_data(type)
