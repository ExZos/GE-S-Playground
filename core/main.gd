extends Node

@onready var screen_container: Node = $ScreenContainer

const INITIAL_SCREEN: StringName = RegistryKeys.Screens.MAIN_MENU_SCREEN

func _enter_tree() -> void:
	EventBus.screen_change_requested.connect(_change_screen)
	EventBus.exit_game_requested.connect(_exit_game)

func _ready() -> void:
	MainRegistry.init()
	
	_load_screen(INITIAL_SCREEN)

func _exit_tree() -> void:
	if EventBus.screen_change_requested.is_connected(_change_screen):
		EventBus.screen_change_requested.disconnect(_change_screen)
	
	if EventBus.exit_game_requested.is_connected(_exit_game):
		EventBus.exit_game_requested.disconnect(_exit_game)
		
func _load_screen(type: String) -> void:
	var screen_scene: PackedScene = MainRegistry.get_screen_scene(type)
	if not screen_scene:
			push_warning("%s: Screen type '%s' not recognized" % [name, type])
			return
	
	var screen_node: Node = screen_scene.instantiate()
	screen_container.add_child(screen_node)

func _change_screen(screen_id: String) -> void:
	for child_node: Node in screen_container.get_children():
		child_node.queue_free()
	
	_load_screen(screen_id)

func _exit_game() -> void:
	get_tree().quit()
