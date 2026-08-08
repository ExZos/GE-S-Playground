extends Control

@export var progress_bar: TextureProgressBar
@export var cooldown_label: Label

@export var target_node: Node
@export var value_prop: StringName
@export var max_prop: StringName

var _fp_fps: float

var last_value: int

func _ready() -> void:
	assert(target_node, "%s: Target node not assigned" % self.name)
	assert(value_prop in target_node, "%s: Property '%s' does not exist in %s" % [self.name, value_prop, target_node.name])
	assert(max_prop in target_node, "%s: Property '%s' does not exist in %s" % [self.name, max_prop, target_node.name])
	
	var fps = Engine.get_physics_ticks_per_second()
	_fp_fps = SGFixed.from_int(fps)
	
	progress_bar.max_value = target_node.get(max_prop)
	progress_bar.hide()

func _process(_delta: float) -> void:
	var value: int = target_node.get(value_prop)
	
	if value != last_value:
		if progress_bar.hidden:
			progress_bar.show()
		
		progress_bar.value = value
		last_value = value
		
		if value > 0:
			cooldown_label.text = "%.1fs" % (value / _fp_fps)
		else:
			progress_bar.hide()
			cooldown_label.text = ""
