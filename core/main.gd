extends Node

@onready var scene_container: Node = $SceneContainer

# TODO: use a scene registry
@export var initial_scene: PackedScene

@export var main_menu_scene: PackedScene
@export var gameplay_scene: PackedScene

func _enter_tree() -> void:
	EventBus.go_to_main_menu.connect(_load_main_menu_scene)
	EventBus.go_to_gameplay.connect(_load_gameplay_scene)

func _ready() -> void:
	var scene_node: Node = initial_scene.instantiate()
	scene_container.add_child(scene_node)

func _exit_tree() -> void:
	if EventBus.go_to_main_menu.is_connected(_load_main_menu_scene):
		EventBus.go_to_main_menu.disconnect(_load_main_menu_scene)
	
	if EventBus.go_to_gameplay.is_connected(_load_gameplay_scene):
		EventBus.go_to_gameplay.disconnect(_load_gameplay_scene)

func _load_main_menu_scene() -> void:
	_free_current_scene()
	
	var scene_node: Node = main_menu_scene.instantiate()
	scene_container.add_child(scene_node)

func _load_gameplay_scene() -> void:
	_free_current_scene()
	
	var scene_node: Node = gameplay_scene.instantiate()
	scene_container.add_child(scene_node)

func _free_current_scene() -> void:
	for child_node: Node in scene_container.get_children():
		child_node.queue_free()
