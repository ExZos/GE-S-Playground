extends Resource

class_name RegistryData

@export var scene: PackedScene: set = _set_scene
var id: int

func _set_scene(value: PackedScene) -> void:
	scene = value
