extends HBoxContainer

# TODO: is this really the best way to handle it?
@export var game_manager: GameManager
@export var character_node: Character

@onready var key_label: Label = $Key
@onready var timer: Timer = $Timer

var _last_is_paused: bool
var _last_is_dead: bool

func _ready() -> void:
	assert(game_manager, "%s: Game manager not assigned" % name)
	assert(character_node, "%s: Character node not assigned" % name)
	
	_last_is_dead = character_node.is_dead
	visible = _last_is_dead
	
	key_label.text = InputDisplayUtils.get_key_text("RespawnText", InputConstants.Bit.RESPAWN)
	
	timer.timeout.connect(_on_timer_timeout)

func _process(_delta: float) -> void:
	var is_dead: bool = character_node.is_dead
	if is_dead != _last_is_dead:
		visible = is_dead
		
		if is_dead:
			timer.start()
		else:
			timer.stop()
		
		_last_is_dead = is_dead
	
	var is_paused = game_manager.is_paused
	if is_paused != _last_is_paused:
		timer.paused = is_paused
		visible = false
		
		_last_is_paused = is_paused

func _on_timer_timeout() -> void:
	visible = !visible
