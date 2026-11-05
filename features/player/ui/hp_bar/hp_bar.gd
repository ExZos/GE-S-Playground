# TODO: better control over dimensions
extends Control

class_name HPBar

@onready var progress_bar: TextureProgressBar = $ProgressBarContainer/TextureProgressBar
@onready var label: Label = $Label

var max_hp: int:
	set(value):
		progress_bar.max_value = value
	
	get:
		return int(progress_bar.max_value)

var current_hp: int:
	set(value):
		progress_bar.value = value
		
		if value > 0: label.text = "%d / %d" % [value, max_hp]
		else: label.text = "DEAD"
	
	get:
		return int(progress_bar.value)

func init(_max_hp: int, _current_hp: int) -> void:
	max_hp = _max_hp
	current_hp = _current_hp
