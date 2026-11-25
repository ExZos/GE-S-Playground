extends Control

class_name PauseMenu

@onready var label: Label = $MenuContainer/Label
@onready var resume_button: Button = $MenuContainer/ButtonContainer/ResumeButton
@onready var main_menu_button: Button = $MenuContainer/ButtonContainer/MainMenuButton

var is_paused: bool:
	set(value):
		visible = value
	
	get:
		return visible

func _exit_tree() -> void:
	if resume_button.button_up.is_connected(_unpause):
		resume_button.button_up.disconnect(_unpause)
		
	if main_menu_button.button_up.is_connected(_go_to_main_menu):
		main_menu_button.button_up.disconnect(_go_to_main_menu)

func init(_is_paused) -> void:
	is_paused = _is_paused
	
	resume_button.button_up.connect(_unpause)
	main_menu_button.button_up.connect(_go_to_main_menu)

func _unpause() -> void:
	GameplayEventBus.current.unpause_requested.emit()

func _go_to_main_menu() -> void:
	GameplayEventBus.current.go_to_main_menu_requested.emit()
