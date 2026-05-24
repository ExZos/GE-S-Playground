extends Node

@export var player: Player
@export var projectile_manager: ProjectileManager
@export var vfx_registry: VFXRegistry

func _ready() -> void:
	vfx_registry.init()

func _process(_delta: float) -> void:
	if not player._vfx_events.is_empty():
		_handle_events(player._vfx_events)
		player._vfx_events.clear()

func _handle_events(vfx_events: Array[VFXEvent]):
	for event in vfx_events:
		var scene: PackedScene = vfx_registry.get_scene(event.type)
		if not scene:
			push_warning("VFXManager: VFX type '%s' not recognized" % event.type)
			continue
		
		var vfx: CPUParticles2D = scene.instantiate()
		vfx.position = event.position
		add_child(vfx)
