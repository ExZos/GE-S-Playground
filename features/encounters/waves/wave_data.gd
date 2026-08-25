@tool
extends RegistryData

# TODO: array of SpawnEvents instead
class_name WaveData

@export var enemies: Array[StringName]

var _enemy_max_dimensions: SGFixedVector2 = SGFixed.vector2(0, 0)

func _validate_property(property: Dictionary) -> void:
	super(property)
	
	if property.name == "enemies":
		property.hint = PROPERTY_HINT_ARRAY_TYPE
		property.hint_string = "%d/%d:%s" % [TYPE_STRING_NAME, PROPERTY_HINT_ENUM, ",".join(RegistryKeys.Enemies.LIST)]
	
func _get_type_hint_string() -> String:
	return ",".join(RegistryKeys.Waves.LIST)

func get_enemy_max_dimensions_in_range(start: int, end: int) -> SGFixedVector2:
	_enemy_max_dimensions.x = 0
	_enemy_max_dimensions.y = 0
	
	for i in range(start, end):
		var enemy_type: StringName = enemies[i]
		if not enemy_type:
			continue
		
		var enemy_data: EnemyData = RegistryManager.get_enemy_data(enemy_type)
		if not enemy_data:
			push_warning("WaveData: Enemy type '%s' not recognized" % enemy_type)
		
		_enemy_max_dimensions.x = max(_enemy_max_dimensions.x, enemy_data.fp_width)
		_enemy_max_dimensions.y = max(_enemy_max_dimensions.y, enemy_data.fp_height)
	
	return _enemy_max_dimensions
