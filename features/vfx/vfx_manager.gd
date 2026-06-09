extends Node

@export var player: Player
@export var projectile_manager: ProjectileManager

func _process(_delta: float) -> void:
	if not player.vfx_events.is_empty():
		_handle_events(player.vfx_events)
		player.vfx_events.clear()

func _handle_events(vfx_events: Array[VFXEvent]):
	for event in vfx_events:
		var vfx_data: VFXData = RegistryManager.get_vfx_data(event.type)
		if not vfx_data:
			push_warning("VFXManager: VFX type '%s' not recognized" % event.type)
			continue
		
		var vfx: CPUParticles2D = vfx_data.scene.instantiate()
		event.apply(vfx)
		
		add_child(vfx)
