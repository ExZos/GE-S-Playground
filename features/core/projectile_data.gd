@tool
extends Resource

class_name ProjectileData

enum ProjectileType { SOLID, SENSOR, UNKNOWN }

@export var scene: PackedScene:
	set(value):
		scene = value
		
		# Only update when in editor
		if Engine.is_editor_hint():
			_update_type()
		
@export var pool_size: int
var type: ProjectileType

# Manually handle showing properties in inspector
func _get_property_list() -> Array:
	var projectile_type_keys = ",".join(ProjectileType.keys())
	
	var properties = []
	properties.append({
		"name": "type",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": projectile_type_keys
	})
	
	return properties

# Set type based on the scene's root node type, the key characteristic of each projectile type
func _update_type() -> void:
	type = ProjectileType.UNKNOWN
	
	if scene == null:
		notify_property_list_changed()
		return
		
	var state: SceneState = scene.get_state()
	if state == null:
		notify_property_list_changed()
		push_warning("ProjectileData: Scene state is null")
		return
		
	var root_type: StringName = state.get_node_type(0)
	match root_type:
		&"SGCharacterBody2D": type = ProjectileType.SOLID
		&"SGArea2D": type = ProjectileType.SENSOR
		
		_: push_warning("ProjectileData: Root node type '%s' not supported" % root_type)
	
	notify_property_list_changed()
