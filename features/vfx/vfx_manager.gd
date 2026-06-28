extends Node

@export var game_manager: GameManager

var vfx_events: Array[VFXEvent] = []

var _pool: Dictionary[StringName, Array] = {}

func _ready() -> void:
	EventBus.vfx_requested.connect(_on_vfx_requested)
	
	for type: StringName in RegistryManager.vfx_registry._lookup:
		var vfx_scene: PackedScene = RegistryManager.get_vfx_scene(type)
		if not vfx_scene:
			push_warning("VFXManager: VFX type '%s' not recognized" % type)
			continue
		
		_pool[type] = []
		
		# TODO: determine pool size better and potentially expand
		for i in range(0, 10):
			var vfx_node: Node2D = vfx_scene.instantiate()
			_pool[type].append(vfx_node)
			add_child(vfx_node)

func _process(_delta: float) -> void:
	if not vfx_events.is_empty():
		for event: VFXEvent in vfx_events:
			# Bypass pooling for code-driven events
			if event.type == CodeDrivenVFXEvent.TYPE:
				event.apply(self)
				continue
			
			var vfx_node: Node2D = get_vfx_node(event.type)
			event.apply(vfx_node)
		
		vfx_events.clear()

func _exit_tree() -> void:
	if EventBus.vfx_requested.is_connected(_on_vfx_requested):
		EventBus.vfx_requested.disconnect(_on_vfx_requested)

func get_vfx_node(type: StringName) -> Node2D:
	for vfx_node: Node2D in _pool[type]:
		if not vfx_node.visible:
			return vfx_node
	
	return null

func _on_vfx_requested(vfx: VFXEvent) -> void:
	# TODO: block if in rollback
	
	vfx_events.append(vfx)
