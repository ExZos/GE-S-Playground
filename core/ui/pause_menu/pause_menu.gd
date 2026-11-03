extends VBoxContainer

# TODO: is this really the best way to handle it?
@export var game_manager: GameManager

@onready var label: Label = $Label

var _last_is_paused: bool

func _ready() -> void:
	assert(game_manager, "%s: Game manager not assigned" % name)
	
	_last_is_paused = game_manager.is_paused
	visible = _last_is_paused

# TODO: functioning menu buttons (that call GameManager's functions?)
func _process(_delta: float) -> void:
	var is_paused: bool = game_manager.is_paused
	
	if is_paused != _last_is_paused:
		visible = is_paused
		
		_last_is_paused = is_paused
