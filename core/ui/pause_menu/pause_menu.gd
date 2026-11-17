extends VBoxContainer

# TODO: functioning menu buttons (that call GameplayScene's functions?)
class_name PauseMenu

@onready var label: Label = $Label
@onready var continue_button: Button = $ContinueButton
@onready var return_button: Button = $ReturnButton

var is_paused: bool:
	set(value):
		visible = value
	
	get:
		return visible

func _exit_tree() -> void:
	if continue_button.button_up.is_connected(_unpause):
		continue_button.button_up.disconnect(_unpause)
		
	if return_button.button_up.is_connected(_go_to_main_menu):
		return_button.button_up.disconnect(_go_to_main_menu)

func init(_is_paused) -> void:
	is_paused = _is_paused
	
	continue_button.button_up.connect(_unpause)
	return_button.button_up.connect(_go_to_main_menu)

func _unpause() -> void:
	GameplayEventBus.current.unpause_requested.emit()

func _go_to_main_menu() -> void:
	GameplayEventBus.current.go_to_main_menu_requested.emit()
