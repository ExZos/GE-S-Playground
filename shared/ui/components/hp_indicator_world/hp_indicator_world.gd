extends Control

@onready var progress_bar_container: PanelContainer = $ProgressBarContainer
@onready var progress_bar: TextureProgressBar = $ProgressBarContainer/TextureProgressBar
@onready var label: Label = $Label

@export var target_node: Node
@export var value_prop: StringName
@export var max_prop: StringName

var last_value: int

func _ready() -> void:
	assert(target_node, "%s: Target node not assigned" % self.name)
	assert(value_prop in target_node, "%s: Property '%s' does not exist in %s" % [self.name, value_prop, target_node.name])
	assert(max_prop in target_node, "%s: Property '%s' does not exist in %s" % [self.name, max_prop, target_node.name])
	
	# TODO: determine dynamically via collision shape or sprite size
	progress_bar_container.custom_minimum_size = custom_minimum_size
	progress_bar.custom_minimum_size = custom_minimum_size
	
	progress_bar.max_value = target_node.get(max_prop)

func _process(_delta: float) -> void:
	var value: int = target_node.get(value_prop)
	
	if value != last_value:
		if progress_bar_container.hidden:
			progress_bar_container.show()
		
		progress_bar.value = value
		last_value = value
		
		if value > 0:
			label.text = str(SGFixed.to_int(value))
		else:
			progress_bar_container.hide()
			label.text = ""
