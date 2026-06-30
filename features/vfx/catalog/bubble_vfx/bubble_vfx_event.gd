extends VFXEvent

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

func reset(_pos: Vector2i, _dir: Vector2i, _speed: int) -> void:
	pos = _pos
	dir = _dir
	speed = _speed

# TODO: investigate speed not affecting sometimes
func apply(vfx_node: Node) -> void:
	vfx_node.position = pos
	vfx_node.direction = dir
	vfx_node.initial_velocity_min = speed
	
	vfx_node.play_effect()
