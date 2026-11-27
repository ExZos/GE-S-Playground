extends Node

@export var screen_registry: ScreenRegistry

func init() -> void:
	screen_registry.init()

func get_screen_scene(type: StringName) -> PackedScene:
	return screen_registry.get_scene(type)
