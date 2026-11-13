extends RefCounted

class_name GameplayEventBus

static var current: GameplayEventBus

@warning_ignore("unused_signal")
signal vfx_requested(vfx_event: VFXEvent)

@warning_ignore("unused_signal")
signal vfx_batch_requested(vfx_events: DenseFixedArray)

# --- GameplayScene simulation ---
var _gameplay_scene: GameplayScene

func register_gameplay_scene(scene: GameplayScene) -> void:
	_gameplay_scene = scene

func get_player_position() -> SGFixedVector2:
	assert(_gameplay_scene, "GameplayEventBus -> get_player_position: GameplayScene not registered")
	
	return _gameplay_scene.get_player_position()

func modify_projectiles(modifier: ProjectileModifier) -> void:
	if _gameplay_scene:
		_gameplay_scene.add_projectile_modifier(modifier)

func get_randi_range(from: int, to: int) -> int:
	assert(_gameplay_scene, "GameplayEventBus -> get_randi_range: GameplayScene not registered")
	
	return _gameplay_scene.get_randi_range(from, to)

# --- EnemyManager simulation
var _enemy_manager: EnemyManager

func register_enemy_manager(manager: EnemyManager) -> void:
	_enemy_manager = manager

func request_projectile(request: ProjectileRequest) -> void:
	if _enemy_manager:
		_enemy_manager.add_projectile_request(request)
