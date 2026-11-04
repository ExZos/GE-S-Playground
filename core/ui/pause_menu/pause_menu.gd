extends VBoxContainer

# TODO: functioning menu buttons (that call GameManager's functions?)
class_name PauseMenu

@onready var label: Label = $Label

var is_paused: bool:
	set(value):
		visible = value
	
	get:
		return visible
