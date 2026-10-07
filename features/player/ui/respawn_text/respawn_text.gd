extends Label

# TODO: highlight key text
@export var character_node: Character

@onready var timer: Timer = $Timer

var _last_is_dead: bool
var key_text: String

func _ready() -> void:
	assert(character_node, "%s: Target node not assigned" % name)
	
	_last_is_dead = character_node.is_dead
	visible = _last_is_dead
	
	key_text = InputDisplayUtils.get_key_text("RespawnText", InputConstants.Bit.NEXT_WAVE)
	text = "Press %s to respawn" % key_text.to_upper()
	
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

func _on_timer_timeout() -> void:
	visible = !visible
