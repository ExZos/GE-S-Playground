extends VFXEvent

# TODO: static class implementation to avoid object creation and pools headaches
# 		pseudo-create() function that returns an array with what would normally be the class' params
#		apply() function that takes node and created array
# TODO: AssetRegistry with sub-registries
class_name BubbleVFXEvent

var pos: Vector2i
var dir: Vector2i
var speed: int

func _init(_pos: Vector2i, _dir: Vector2i, _speed: int) -> void:
	super(RegistryKeys.VFX.BUBBLE_VFX)
	
	pos = _pos
	dir = _dir
	speed = _speed

func apply(vfx_node: Node2D) -> void:
	vfx_node.position = pos
	vfx_node.direction = dir
	vfx_node.initial_velocity_min = speed
