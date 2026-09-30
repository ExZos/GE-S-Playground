@tool
extends Character

# TODO: check if can have base enemy scene and parameterize things like EnemyAI class
class_name Enemy

#
var enemy_data: EnemyData:
	get():
		return character_data as EnemyData

# Misc - used by other nodes
var type: StringName # Key for determining which pool it belongs to

func init(data: CharacterData) -> void:
	super(data)
	
	# TODO: use enemy_data to access EnemyData fields
	
	type = enemy_data.type
	
	collision_shape.shape.extents.x = SGFixed.from_int(enemy_data.half_width)
	collision_shape.shape.extents.y = SGFixed.from_int(enemy_data.half_height)

func add_projectile_request(request: ProjectileRequest) -> void:
	EventBus.request_projectile(request)
