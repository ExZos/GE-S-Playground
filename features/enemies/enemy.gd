@tool
extends Character

# TODO: check if can have base enemy scene and parameterize things like EnemyAI class
class_name Enemy

@export var _enemy_input: EnemyInput

#
var enemy_data: EnemyData:
	get():
		return character_data as EnemyData

# Move ticks
var fp_min_move_duration: int
var fp_max_move_duration: int
var fp_move_ticks: int

# Attack ticks
var fp_min_attack_cooldown: int
var fp_max_attack_cooldown: int
var fp_attack_ticks: int 

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
	
	fp_min_move_duration = enemy_data.fp_min_move_duration
	fp_max_move_duration = enemy_data.fp_max_move_duration
	fp_move_ticks = 0
	
	fp_min_attack_cooldown = enemy_data.fp_min_attack_cooldown
	fp_max_attack_cooldown = enemy_data.fp_max_attack_cooldown
	fp_attack_ticks = 0

func advance_frame(input_mask: int, prev_input_mask: int) -> void:
	if fp_move_ticks > 0:
		fp_move_ticks -= SGFixed.ONE
	
	if fp_attack_ticks > 0:
		fp_attack_ticks -= SGFixed.ONE
	 
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
func can_move() -> bool:
	if fp_move_ticks > 0:
		return false
		
	fp_move_ticks = EventBus.get_randi_range(fp_min_move_duration, fp_max_move_duration)
	return true

func can_attack() -> bool:
	if fp_attack_ticks > 0:
		return false
		
	fp_attack_ticks = EventBus.get_randi_range(fp_min_attack_cooldown, fp_max_attack_cooldown)
	return true
	
