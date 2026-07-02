extends Node

@export var game_manager: GameManager

const VFX_POOL_SIZE: int = 50

var vfx_events: Array[VFXEvent] = []

var _vfx_pool: Dictionary[StringName, Array] = {}

func _ready() -> void:
	EventBus.vfx_requested.connect(_on_vfx_requested)
	EventBus.vfx_batch_requested.connect(_on_vfx_batch_requested)
	
	for type: StringName in RegistryManager.vfx_registry._lookup:
		var vfx_scene: PackedScene = RegistryManager.get_vfx_scene(type)
		if not vfx_scene:
			push_warning("VFXManager: VFX type '%s' not recognized" % type)
			continue
		
		_vfx_pool[type] = []
		_vfx_pool[type].resize(VFX_POOL_SIZE)
		
		for i in range(VFX_POOL_SIZE):
			var vfx: Node2D = vfx_scene.instantiate()
			_vfx_pool[type][i] = vfx
			add_child(vfx)

func _process(_delta: float) -> void:
	if not vfx_events.is_empty():
		for event: VFXEvent in vfx_events:
			var vfx: Node2D = get_vfx(event.type)
			event.apply(vfx)
		
		vfx_events.clear()

func _exit_tree() -> void:
	if EventBus.vfx_requested.is_connected(_on_vfx_requested):
		EventBus.vfx_requested.disconnect(_on_vfx_requested)
	
	if EventBus.vfx_batch_requested.is_connected(_on_vfx_batch_requested):
		EventBus.vfx_batch_requested.disconnect(_on_vfx_batch_requested)

func get_vfx(type: StringName) -> Node2D:
	for vfx: Node2D in _vfx_pool[type]:
		if not vfx.visible:
			return vfx
	
	push_warning("VFXManager: No VFX type '%s' available, creating one. Total VFX: %d" % [type, _vfx_pool[type].size()])
	var vfx_scene: PackedScene = RegistryManager.get_vfx_scene(type)
	if not vfx_scene:
		push_warning("VFXManager: VFX type '%s' not recognized" % type)
		return null
	
	var vfx: Node2D = vfx_scene.instantiate()
	_vfx_pool[type].append(vfx)
	add_child(vfx)
	
	return vfx

func _on_vfx_requested(event: VFXEvent) -> void:
	# TODO: block if in rollback frame
	
	vfx_events.append(event)

func _on_vfx_batch_requested(events: Array[VFXEvent], count: int) -> void:
	# TODO: block if in rollback frame
	
	for i in range(count):
		vfx_events.append(events[i])
