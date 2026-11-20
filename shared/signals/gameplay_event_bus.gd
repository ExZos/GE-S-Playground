extends Node

class_name GameplayEventBus

static var current: GameplayEventBus

# --- UI event signals
@warning_ignore("unused_signal")
signal unpause_requested()

@warning_ignore("unused_signal")
signal go_to_main_menu_requested()

# --- VFX signals
@warning_ignore("unused_signal")
signal vfx_requested(vfx_event: VFXEvent)

@warning_ignore("unused_signal")
signal vfx_batch_requested(vfx_events: DenseFixedArray)

# --- GameplayScreen simulation ---
var _gameplay_screen: GameplayScreen

func _enter_tree() -> void:
	current = self

func _exit_tree() -> void:
	if current == self:
		current = null

func register_gameplay_screen(screen: GameplayScreen) -> void:
	_gameplay_screen = screen

func get_player_position() -> SGFixedVector2:
	assert(_gameplay_screen, "GameplayEventBus -> get_player_position: GameplayScreen not registered")
	
	return _gameplay_screen.get_player_position()

func modify_projectiles(modifier: ProjectileModifier) -> void:
	if _gameplay_screen:
		_gameplay_screen.add_projectile_modifier(modifier)

func get_randi_range(from: int, to: int) -> int:
	assert(_gameplay_screen, "GameplayEventBus -> get_randi_range: GameplayScreen not registered")
	
	return _gameplay_screen.get_randi_range(from, to)

# --- EnemyManager simulation
var _enemy_manager: EnemyManager

func register_enemy_manager(manager: EnemyManager) -> void:
	_enemy_manager = manager

func request_projectile(request: ProjectileRequest) -> void:
	if _enemy_manager:
		_enemy_manager.add_projectile_request(request)
