extends Control

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var exit_button: Button = $VBoxContainer/ExitButton

func _ready() -> void:
	play_button.button_up.connect(_go_to_gameplay)
	settings_button.button_up.connect(_go_to_settings)
	exit_button.button_up.connect(_exit_game)

func _exit_tree() -> void:
	if play_button.button_up.is_connected(_go_to_gameplay):
		play_button.button_up.disconnect(_go_to_gameplay)
	
	if settings_button.button_up.is_connected(_go_to_settings):
		settings_button.button_up.disconnect(_go_to_settings)
	
	if exit_button.button_up.is_connected(_exit_game):
		exit_button.button_up.disconnect(_exit_game)

func _go_to_gameplay() -> void:
	EventBus.go_to_screen.emit(RegistryKeys.Screens.GAMEPLAY_SCREEN)

func _go_to_settings() -> void:
	print("TODO: go to settings")

func _exit_game() -> void:
	print("TODO: exit game")
