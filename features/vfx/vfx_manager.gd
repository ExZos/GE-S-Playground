extends Node

@export var game_manager: GameManager

# TODO: find better way to determine this for each vfx type
const VFX_POOL_SIZE: int = 50

var _vfx_events: Array[VFXEvent] = []
var _vfx_events_count: int = 0

var _vfx_pools: Dictionary[StringName, Array] = {}

func _ready() -> void:
	EventBus.vfx_requested.connect(_on_vfx_requested)
	EventBus.vfx_batch_requested.connect(_on_vfx_batch_requested)
	
	# Fill vfx pools
	for type: StringName in RegistryManager.vfx_registry._lookup:
		var vfx_scene: PackedScene = RegistryManager.get_vfx_scene(type)
		if not vfx_scene:
			push_warning("VFXManager: VFX type '%s' not recognized" % type)
			continue
		
		_vfx_pools[type] = []
		_vfx_pools[type].resize(VFX_POOL_SIZE)
		
		for i in range(VFX_POOL_SIZE):
			var vfx: Node2D = vfx_scene.instantiate()
			_vfx_pools[type][i] = vfx
			add_child(vfx)
	
	# Determine appropriate vfx events size based on vfx pools
	_vfx_events.resize(VFX_POOL_SIZE * _vfx_pools.size())

func _process(_delta: float) -> void:
	if _vfx_events_count > 0:
		for i in range(_vfx_events_count):
			var event: VFXEvent = _vfx_events[i]
			
			var vfx: Node2D = get_vfx(event.type)
			event.apply(vfx)
			
			_vfx_events[i] = null
		
		_vfx_events_count = 0

func _exit_tree() -> void:
	if EventBus.vfx_requested.is_connected(_on_vfx_requested):
		EventBus.vfx_requested.disconnect(_on_vfx_requested)
	
	if EventBus.vfx_batch_requested.is_connected(_on_vfx_batch_requested):
		EventBus.vfx_batch_requested.disconnect(_on_vfx_batch_requested)

func get_vfx(type: StringName) -> Node2D:
	for vfx: Node2D in _vfx_pools[type]:
		if not vfx.visible:
			return vfx
	
	push_warning("VFXManager: No VFX type '%s' available, creating one. Total VFX: %d" % [type, _vfx_pools[type].size()])
	var vfx_scene: PackedScene = RegistryManager.get_vfx_scene(type)
	if not vfx_scene:
		push_warning("VFXManager: VFX type '%s' not recognized" % type)
		return null
	
	var vfx: Node2D = vfx_scene.instantiate()
	_vfx_pools[type].append(vfx)
	add_child(vfx)
	
	return vfx

func _on_vfx_requested(event: VFXEvent) -> void:
	# TODO: block if in rollback frame
	
	_vfx_events[_vfx_events_count] = event
	_vfx_events_count += 1

func _on_vfx_batch_requested(events: Array[VFXEvent], count: int) -> void:
	# TODO: block if in rollback frame
	
	for i in range(count):
		_vfx_events[_vfx_events_count + i] = events[i]
	
	_vfx_events_count += count
