extends VBoxContainer

# TODO: functioning menu buttons (that call GameplayScene's functions?)
class_name PauseMenu

@onready var label: Label = $Label

var is_paused: bool:
	set(value):
		visible = value
	
	get:
		return visible

func init(_is_paused) -> void:
	is_paused = _is_paused
