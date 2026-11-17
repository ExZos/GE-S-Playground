extends Control

@onready var play_button: Button = $VBoxContainer/PlayButton

func _ready() -> void:
	play_button.button_up.connect(_go_to_gameplay)

func _exit_tree() -> void:
	if play_button.button_up.is_connected(_go_to_gameplay):
		play_button.button_up.disconnect(_go_to_gameplay)

func _go_to_gameplay() -> void:
	EventBus.go_to_gameplay.emit()
