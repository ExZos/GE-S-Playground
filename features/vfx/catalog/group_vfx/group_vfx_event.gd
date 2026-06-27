extends CodeDrivenVFXEvent

class_name GroupVFXEvent

enum SpawnDataIndex {
	POS_X,
	POS_Y,
	DIR_X,
	DIR_Y,
	SPEED
}

var vfx_type: StringName
var spawn_data_list: Array[PackedInt64Array]

func _init(_vfx_type: StringName, _spawn_data_list: Array[PackedInt64Array]) -> void:
	super()
	
	vfx_type = _vfx_type
	spawn_data_list = _spawn_data_list

func apply(vfx_node: Node2D) -> void:
	var vfx_scene: PackedScene = RegistryManager.get_vfx_scene(vfx_type)
	if not vfx_scene:
		push_warning("GroupVFXEvent: VFX type '%s' not recognized" % vfx_type)
		return
		
	for spawn_data in spawn_data_list:
		var vfx: Node2D = vfx_scene.instantiate()
		
		vfx.position.x = spawn_data[SpawnDataIndex.POS_X]
		vfx.position.y = spawn_data[SpawnDataIndex.POS_Y]
		vfx.direction.x = spawn_data[SpawnDataIndex.DIR_X]
		vfx.direction.y = spawn_data[SpawnDataIndex.DIR_Y]
		vfx.initial_velocity_min = spawn_data[SpawnDataIndex.SPEED]
		
		vfx_node.add_child(vfx)
	
	spawn_data_list.clear()

func add_spawn_data(pos: Vector2i, dir: Vector2i, speed: int) -> void:
	var spawn_data: PackedInt64Array = PackedInt64Array()
	spawn_data.resize(5)
	
	spawn_data[SpawnDataIndex.POS_X] = pos.x
	spawn_data[SpawnDataIndex.POS_Y] = pos.y
	spawn_data[SpawnDataIndex.DIR_X] = dir.x
	spawn_data[SpawnDataIndex.DIR_Y] = dir.y
	spawn_data[SpawnDataIndex.SPEED] = speed
	
	spawn_data_list.append(spawn_data)
