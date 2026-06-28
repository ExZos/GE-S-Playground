extends RefCounted

class_name VFXEvent

var type: StringName

func _init(_type: StringName) -> void:
	type = _type

func apply(_vfx_node: Node) -> void:
	pass
