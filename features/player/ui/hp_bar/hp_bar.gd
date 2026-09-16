# TODO: better control over dimensions
extends Control

@onready var progress_bar: TextureProgressBar = $ProgressBarContainer/TextureProgressBar
@onready var label: Label = $Label

@export var target_node: Node
@export var value_prop: StringName = &"fp_current_hp"
@export var max_prop: StringName = &"fp_max_hp"

var _max_hp: int
var _last_value: int

func _ready() -> void:
	assert(target_node, "%s: Target node not assigned" % self.name)
	assert(value_prop in target_node, "%s: Property '%s' does not exist in %s" % [self.name, value_prop, target_node.name])
	assert(max_prop in target_node, "%s: Property '%s' does not exist in %s" % [self.name, max_prop, target_node.name])
	
	progress_bar.max_value = target_node.get(max_prop)
	_max_hp = SGFixed.to_int(progress_bar.max_value)

func _process(_delta: float) -> void:
	var value: int = target_node.get(value_prop)
	
	if value != _last_value:
		progress_bar.value = value
		_last_value = value
		
		if value > 0:
			label.text = "%d / %d" % [SGFixed.to_int(value), _max_hp]
		else:
			label.text = "DEAD"
