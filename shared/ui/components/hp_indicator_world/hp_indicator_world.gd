extends Control

@onready var progress_bar_container: PanelContainer = $ProgressBarContainer
@onready var progress_bar: TextureProgressBar = $ProgressBarContainer/TextureProgressBar
@onready var label: Label = $Label

@export var character_node: Character
@export var show_hp_text: bool = true

@export var min_width: int = 50
@export var min_height: int = 10

var _last_value: int

func _ready() -> void:
	assert(character_node, "%s: Character node not assigned" % name)
	
	var character_half_width: int = SGFixed.to_int(character_node.fp_half_width)
	var character_half_height: int = SGFixed.to_int(character_node.fp_half_height)
	
	# Set dimensions based on the character node's
	size.x = max(character_half_width * 2, min_width)
	size.y = max(character_half_height * 0.1, min_height)
	
	# Set position based on dimensions
	position.x = -size.x/2
	position.y = -character_half_height - (size.y * 2)
	
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
