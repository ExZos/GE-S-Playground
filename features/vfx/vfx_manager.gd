extends Node

@export var game_manager: GameManager

# TODO: find better way to determine this for each vfx type
const VFX_POOL_SIZE: int = 50

var _vfx_events: DenseFixedArray

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
	_vfx_events = DenseFixedArray.new(VFX_POOL_SIZE, VFXEvent)

func _process(_delta: float) -> void:
	if _vfx_events.count > 0:
		for i in range(_vfx_events.count):
			var event: VFXEvent = _vfx_events.data[i]
			
			var vfx: Node2D = get_vfx(event.type)
			event.apply(vfx)
		
		_vfx_events.clear_data()

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
	
	if not _vfx_events.add_item(event):
		push_warning("VFXManager: No VFX event available, creating one. Total VFX events: %d" % _vfx_events.max_size)
		_vfx_events.data.resize(_vfx_events.max_size + 1)
		_vfx_events.max_size += 1
		
		_vfx_events.add_item(event)

func _on_vfx_batch_requested(events: DenseFixedArray) -> void:
	# TODO: block if in rollback frame
	
	if not _vfx_events.add_batch(events):
		var available: int = _vfx_events.max_size - _vfx_events.count
		var missing: int = events.count - available
		
		push_warning("VFXManager: Not enough VFX events available, creating %d. %d requested but %d available. Total VFX events: %d" % [missing, events.count, available, _vfx_events.max_size])
		_vfx_events.data.resize(_vfx_events.max_size + missing)
		_vfx_events.max_size += missing
		
		_vfx_events.add_batch(events)
