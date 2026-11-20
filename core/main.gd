extends Node

@onready var screen_container: Node = $ScreenContainer

const INITIAL_SCREEN: StringName = RegistryKeys.Screens.GAMEPLAY_SCREEN

func _enter_tree() -> void:
	EventBus.go_to_screen.connect(_swap_screen)

func _ready() -> void:
	MainRegistry.init()
	
	_load_screen(INITIAL_SCREEN)

func _exit_tree() -> void:
	if EventBus.go_to_screen.is_connected(_swap_screen):
		EventBus.go_to_screen.disconnect(_swap_screen)

func _load_screen(type: String) -> void:
	var screen_scene: PackedScene = MainRegistry.get_screen_scene(type)
	if not screen_scene:
			push_warning("%s: Screen type '%s' not recognized" % [name, type])
			return
	
	var screen_node: Node = screen_scene.instantiate()
	screen_container.add_child(screen_node)

func _swap_screen(screen_id: String) -> void:
	for child_node: Node in screen_container.get_children():
		child_node.queue_free()
	
	_load_screen(screen_id)
