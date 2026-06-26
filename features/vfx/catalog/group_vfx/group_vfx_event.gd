extends VFXEvent

class_name GroupVFXEvent

var vfx_type: StringName
var spawn_data_list: Array[PackedInt64Array]

func _init(_vfx_type: StringName, _spawn_data_list: Array[PackedInt64Array]) -> void:
	super(RegistryKeys.VFX.GROUP_VFX)
	
	vfx_type = _vfx_type
	spawn_data_list = _spawn_data_list

func apply(vfx_node: Node2D) -> void:
	var vfx_scene: PackedScene = RegistryManager.get_vfx_scene(vfx_type)
	if not vfx_scene:
		push_warning("GroupVFXEvent: VFX type '%s' not recognized" % vfx_type)
		return
		
	for spawn_data in spawn_data_list:
		var vfx: Node2D = vfx_scene.instantiate()
		
		vfx.position.x = spawn_data[0]
		vfx.position.y = spawn_data[1]
		vfx.direction.x = spawn_data[2]
		vfx.direction.y = spawn_data[3]
		vfx.initial_velocity_min = spawn_data[4]
		
		vfx_node.add_child(vfx)
	
	spawn_data_list.clear()

func add_spawn_data(pos: Vector2i, dir: Vector2i, speed: int) -> void:
	var spawn_data: PackedInt64Array = PackedInt64Array()
	spawn_data.resize(5)
	
	spawn_data[0] = pos.x
	spawn_data[1] = pos.y
	spawn_data[2] = dir.x
	spawn_data[3] = dir.y
	spawn_data[4] = speed
	
	spawn_data_list.append(spawn_data)
