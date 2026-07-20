extends Node

@export var game_manager: GameManager

# TODO: find better way to determine this for each vfx type
const VFX_POOL_SIZE: int = 50

var _vfx_events: DenseFixedArray

var _vfx_pools: Dictionary[StringName, SparsePassiveFixedArray] = {}

func _ready() -> void:
	EventBus.vfx_requested.connect(_on_vfx_requested)
	EventBus.vfx_batch_requested.connect(_on_vfx_batch_requested)
	
	# Fill vfx pools
	for type: StringName in RegistryManager.vfx_registry._lookup:
		var vfx_scene: PackedScene = RegistryManager.get_vfx_scene(type)
		if not vfx_scene:
			push_warning("VFXManager: VFX type '%s' not recognized" % type)
			continue
		
		# TODO: might need to expand vfx types
		_vfx_pools[type] = SparsePassiveFixedArray.new(VFX_POOL_SIZE, OneShotParticle)
		for i in range(VFX_POOL_SIZE):
			var vfx: OneShotParticle = vfx_scene.instantiate()
			vfx.deactivate()
			
			_vfx_pools[type].data[i] = vfx
			add_child(vfx)
	
	# Determine appropriate vfx events size based on vfx pools
	_vfx_events = DenseFixedArray.new(VFX_POOL_SIZE, VFXEvent)

func _process(_delta: float) -> void:
	if _vfx_events.count > 0:
		for i in range(_vfx_events.count):
			var event: VFXEvent = _vfx_events.data[i]
			
			var vfx: OneShotParticle = get_vfx(event.type)
			event.apply(vfx)
		
		_vfx_events.clear_data()

func _exit_tree() -> void:
	if EventBus.vfx_requested.is_connected(_on_vfx_requested):
		EventBus.vfx_requested.disconnect(_on_vfx_requested)
	
	if EventBus.vfx_batch_requested.is_connected(_on_vfx_batch_requested):
		EventBus.vfx_batch_requested.disconnect(_on_vfx_batch_requested)

func get_vfx(type: StringName) -> OneShotParticle:
	var pool: SparsePassiveFixedArray = _vfx_pools[type]
	
	var vfx: OneShotParticle = pool.get_next_inactive()
	if not vfx:
		var vfx_scene: PackedScene = RegistryManager.get_vfx_scene(type)
		if not vfx_scene:
			push_warning("VFXManager: VFX type '%s' not recognized" % type)
			return null
		
		# Expand pool and manually fill
		var old_pool_max_size: int = pool.max_size
		pool.forced_expand("VFXManager -> VFX '%s' pool" % type, 1)
		for i in range(old_pool_max_size, pool.max_size):
			vfx = vfx_scene.instantiate()
			pool.data[i] = vfx
			add_child(vfx)
		
		vfx = pool.data[old_pool_max_size]
	
	return vfx

func _on_vfx_requested(event: VFXEvent) -> void:
	# TODO: block if in rollback frame
	
	if _vfx_events.add_item(event) == -1:
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
