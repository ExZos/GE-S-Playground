extends RefCounted

class_name VFXEvent

var type: VFXData.Type
var position: Vector2

func _init(_type: VFXData.Type, _position: Vector2) -> void:
	type = _type
	position = _position
