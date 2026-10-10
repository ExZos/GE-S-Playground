extends Control

@onready var progress_bar_container: PanelContainer = $ProgressBarContainer
@onready var progress_bar: TextureProgressBar = $ProgressBarContainer/TextureProgressBar
@onready var label: Label = $Label

@export var character_node: Character
@export var show_hp_text: bool = true

var _last_value: int

func _ready() -> void:
	assert(character_node, "%s: Character node not assigned" % name)
	
	# Set progress bar container's width to the collision shape's width
	var parent: Node2D = get_parent()
	var collision_shape: SGCollisionShape2D = parent.find_child("SGCollisionShape2D")
	var shape_size: Vector2 = SGShape2DUtils.get_size(collision_shape.shape, collision_shape.global_scale)
	progress_bar_container.custom_minimum_size.x = shape_size.x
	
	progress_bar.max_value = character_node.fp_max_hp
	
	if not show_hp_text:
		label.hide()

func _process(_delta: float) -> void:
	var value: int = character_node.fp_current_hp
	
	if value != _last_value:
		if progress_bar_container.hidden:
			progress_bar_container.show()
		
		progress_bar.value = value
		_last_value = value
		
		if value > 0:
			label.text = "%d" % SGFixed.to_int(value)
		else:
			progress_bar_container.hide()
			label.text = ""
