extends RefCounted

class_name VFXEvent

var type: VFXData.Type

func _init(_type: VFXData.Type) -> void:
	type = _type

func apply(_vfx_node: Node2D) -> void:
	pass
