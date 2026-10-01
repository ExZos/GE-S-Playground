@tool
extends Character

# TODO: check if can have base enemy scene and parameterize things like EnemyAI class
class_name Enemy

@export var _enemy_input: EnemyInput

#
var enemy_data: EnemyData:
	get():
		return character_data as EnemyData

# Action
var fp_min_action_duration: int
var fp_max_action_duration: int
var fp_action_ticks: int

# Misc - used by other nodes
var type: StringName # Key for determining which pool it belongs to

func _validate_property(property: Dictionary) -> void:
	super(property)
	
	if property.name == "character_data":
		property.hint = PROPERTY_HINT_RESOURCE_TYPE
		property.hint_string = "EnemyData"

func init(data: CharacterData) -> void:
	super(data)
	
	# TODO: use enemy_data to access EnemyData fields
	
	type = enemy_data.type
	
	fp_min_action_duration = enemy_data.fp_min_action_duration
	fp_max_action_duration = enemy_data.fp_max_action_duration
	
	collision_shape.shape.extents.x = SGFixed.from_int(enemy_data.half_width)
	collision_shape.shape.extents.y = SGFixed.from_int(enemy_data.half_height)

func advance_frame(input_mask: int, prev_input_mask: int) -> void:
	if fp_action_ticks > 0:
		fp_action_ticks -= SGFixed.ONE
	 
	super(input_mask, prev_input_mask)

# --- Projectile request wrappers ---
func add_projectile_request(request: ProjectileRequest) -> void:
	EventBus.request_projectile(request)

# --- EnemyInput wrappers ---
func get_input_mask(prev_input_mask: int) -> int:
	return _enemy_input.get_input_mask(self, prev_input_mask)

func handle_collision(input_mask: int) -> int:
	return _enemy_input.handle_collision(self, input_mask)

#
func can_act() -> bool:
	if fp_action_ticks > 0:
		return false
		
	fp_action_ticks = EventBus.get_randi_range(fp_min_action_duration, fp_max_action_duration)
	return true
