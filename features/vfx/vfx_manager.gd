extends Node

@export var player: Player
@export var projectile_manager: ProjectileManager

func _process(_delta: float) -> void:
	if not player.vfx_events.is_empty():
		_handle_events(player.vfx_events)
		player.vfx_events.clear()

func _handle_events(vfx_events: Array[VFXEvent]):
	for event in vfx_events:
		var vfx_scene: PackedScene = RegistryManager.get_vfx_scene(event.type)
		if not vfx_scene:
			push_warning("VFXManager: VFX type '%s' not recognized" % event.type)
			continue
		
		var vfx: CPUParticles2D = vfx_scene.instantiate()
		event.apply(vfx)
		
		add_child(vfx)
