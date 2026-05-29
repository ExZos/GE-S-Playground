@tool
extends RegistryData

class_name ProjectileData

enum Type {
	SENSOR,
	SOLID
}

enum Base { SOLID, SENSOR, UNKNOWN }

@export_group("Core")
@export var type: Type:
	set(value):
		type = value
		id = value
		
@export var base: Base
@export_range(0, 500) var pool_size: int # TODO: automatically compute based on stats

@export_group("Stats")
@export var speed: int

func _set_scene(value: PackedScene) -> void:
	scene = value
	
	# Only update when in editor
	if Engine.is_editor_hint():
		_update_base()

func _validate_property(property: Dictionary):
	if property.name == "base":
		property.usage |= PROPERTY_USAGE_READ_ONLY

# Set base according to scene's root node type, the key characteristic of each projectile type
func _update_base() -> void:
	base = Base.UNKNOWN
	
	if scene == null:
		notify_property_list_changed()
		return
		
	var state: SceneState = scene.get_state()
	if state == null:
		notify_property_list_changed()
		push_error("ProjectileData: Scene state is null")
		return
		
	var root_type: StringName = state.get_node_type(0)
	match root_type:
		&"SGCharacterBody2D": base = Base.SOLID
		&"SGArea2D": base = Base.SENSOR
		
		_: push_error("ProjectileData: Root node type '%s' not supported" % root_type)
	
	notify_property_list_changed()
