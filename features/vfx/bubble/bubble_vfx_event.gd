extends VFXEvent

# TODO: asset ids for texture, gradient, etc...
# TODO: AssetRegistry with sub-registries
class_name BubbleVFXEvent

var pos: Vector2i
var dir: Vector2i
var speed: int

func _init(_pos: Vector2i, _dir: Vector2i, _speed) -> void:
	super(VFXData.Type.BUBBLE_VFX)
	
	pos = _pos
	dir = _dir
	speed = _speed

func apply(vfx_node: Node2D) -> void:
	vfx_node.position = pos
	vfx_node.direction = dir
	vfx_node.initial_velocity_min = speed
