extends Node

@onready var scene_container: Node = $SceneContainer

@export var initial_scene: PackedScene

@export var main_menu_scene: PackedScene
@export var gameplay_scene: PackedScene

func _ready() -> void:
	var scene_node: Node = initial_scene.instantiate()
	scene_container.add_child(scene_node)
