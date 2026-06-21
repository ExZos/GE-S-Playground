@tool
extends RegistryData

class_name ProjectileData

# Core behavior determined by its root node
# Next id: 2
enum Base {
	NONE = -1,
	SENSOR = 0,
	SOLID = 1
}

@export_group("Core")
@export var base: Base
@export_range(0, 500) var pool_size: int # TODO: automatically compute based on stats

@export_group("Stats")
@export var base_speed: int

func _validate_property(property: Dictionary):
	super(property)
	
	if property.name == "base":
		property.usage |= PROPERTY_USAGE_READ_ONLY

func _get_type_hint_string() -> String:
	return Type.LIST

func _set_scene(value: PackedScene) -> void:
	scene = value
	
	# Only update when in editor
	if Engine.is_editor_hint():
		_update_base()

# Set base according to scene's root node type, the key characteristic of each projectile type
func _update_base() -> void:
	base = Base.NONE
	
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

class Type extends RefCounted:
	const SENSOR: StringName = &"sensor_projectile"
	const SOLID: StringName = &"solid_projectile"
	
	const LIST =\
		SENSOR + "," +\
		SOLID
