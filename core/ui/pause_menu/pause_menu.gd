extends VBoxContainer

# TODO: is this really the best way to handle it?
@export var game_manager: GameManager

@onready var label: Label = $Label

var _last_paused: bool

func _ready() -> void:
	assert(game_manager, "%s: Game manager not assigned" % name)
	
	_last_paused = game_manager.paused
	visible = _last_paused

# TODO: functioning menu buttons (that call GameManager's functions?)
func _process(_delta: float) -> void:
	var paused: bool = game_manager.paused
	
	if paused != _last_paused:
		visible = paused
		
		_last_paused = paused
