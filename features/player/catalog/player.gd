@tool
extends Character

# TODO: consider _process to handle presentation logic
class_name Player

const PROJECTILE_REQUESTS_POOL_SIZE: int = 5

#
var player_data: PlayerData:
	get():
		return character_data as PlayerData

# 
var projectile_requests: DenseFixedArray

func _validate_property(property: Dictionary) -> void:
	super(property)
	
	if property.name == "character_data":
		property.hint = PROPERTY_HINT_RESOURCE_TYPE
		property.hint_string = "PlayerData"

func init(data: CharacterData) -> void:
	super(data)
	
	# TODO: use player_data to access PlayerData fields
	
	projectile_requests = DenseFixedArray.new(PROJECTILE_REQUESTS_POOL_SIZE, TYPE_OBJECT, ProjectileRequest)

func reset() -> void:
	super()
	
	projectile_requests.clear_data()

# --- Skill manager getters ---
func get_attack() -> Skill:
	return skill_manager._attack

func get_skills() -> Array[Skill]:
	return skill_manager._skills

# --- Projectile request wrappers ---
func add_projectile_request(request: ProjectileRequest) -> void:
	if projectile_requests.add_item(request) == -1:
		projectile_requests.forced_expand("Player -> Projectile requests", 1)
		
		projectile_requests.add_item(request)

func clear_projectile_requests() -> void:
	projectile_requests.clear_data()
