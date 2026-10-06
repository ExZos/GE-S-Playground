# TODO: better control over dimensions
extends Control

@onready var progress_bar: TextureProgressBar = $ProgressBarContainer/TextureProgressBar
@onready var label: Label = $Label

@export var character_node: Character
@export var value_prop: StringName = &"fp_current_hp"
@export var max_prop: StringName = &"fp_max_hp"

var _max_hp: int
var _last_value: int

func _ready() -> void:
	assert(character_node, "%s: Character node not assigned" % name)
	assert(value_prop in character_node, "%s: Property '%s' does not exist in %s" % [name, value_prop, character_node.name])
	assert(max_prop in character_node, "%s: Property '%s' does not exist in %s" % [name, max_prop, character_node.name])
	
	progress_bar.max_value = character_node.get(max_prop)
	_max_hp = SGFixed.to_int(progress_bar.max_value)

func _process(_delta: float) -> void:
	var value: int = character_node.get(value_prop)
	
	if value != _last_value:
		progress_bar.value = value
		_last_value = value
		
		if value > 0:
			label.text = "%d / %d" % [SGFixed.to_int(value), _max_hp]
		else:
			label.text = "DEAD"
