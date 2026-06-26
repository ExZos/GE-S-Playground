extends Node2D

func apply_data(vfx_type: StringName, spawn_data_list: Array[PackedInt64Array]) -> void:
	var vfx_scene: PackedScene = RegistryManager.get_vfx_scene(vfx_type)
	if not vfx_scene:
		push_warning("VFXManager: VFX type '%s' not recognized" % vfx_type)
		return
		
	for spawn_data in spawn_data_list:
		var vfx: Node2D = vfx_scene.instantiate()
		
		vfx.position.x = spawn_data[0]
		vfx.position.y = spawn_data[1]
		vfx.direction.x = spawn_data[2]
		vfx.direction.y = spawn_data[3]
		vfx.initial_velocity_min = spawn_data[4]
		
		add_child(vfx)
