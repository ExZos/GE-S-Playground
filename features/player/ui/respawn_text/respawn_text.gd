extends HBoxContainer

class_name RespawnText

@onready var key_label: Label = $Key
@onready var timer: Timer = $Timer

var is_dead: bool:
	set(value):
		if value:
			timer.start()
			visible = true
		else:
			timer.stop()
			visible = false
	
	get:
		return !timer.is_stopped()

var is_paused: bool:
	set(value):
		timer.paused = value
		visible = false
	
	get:
		return timer.paused

func _ready() -> void:
	# TODO: parameterize this
	key_label.text = InputDisplayUtils.get_key_text("RespawnText", InputConstants.Bit.RESPAWN)
	
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	visible = !visible
