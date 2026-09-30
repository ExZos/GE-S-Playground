extends Node

@warning_ignore("unused_signal")
signal vfx_requested(vfx_event: VFXEvent)

@warning_ignore("unused_signal")
signal vfx_batch_requested(vfx_events: DenseFixedArray)

# --- GameManager simulation ---
var _game_manager: GameManager

func register_game_manager(manager: GameManager) -> void:
	_game_manager = manager

func modify_projectiles(modifier: ProjectileModifier) -> void:
	if _game_manager:
		_game_manager.add_projectile_modifier(modifier)

# --- EnemyManager simulation
var _enemy_manager: EnemyManager

func register_enemy_manager(manager: EnemyManager) -> void:
	_enemy_manager = manager

func request_projectile(request: ProjectileRequest) -> void:
	if _enemy_manager:
		_enemy_manager.add_projectile_request(request)
