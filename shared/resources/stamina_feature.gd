@tool
extends SkillFeature

class_name StaminaFeature

@export var max_stamina: int = 50:
	set(value):
		max_stamina = max(1, value)
		
		if starting_stamina > max_stamina:
			starting_stamina = max_stamina
		
		notify_property_list_changed()
	
@export var starting_stamina: int = 50:
	set(value):
		starting_stamina = clampi(value, 0, max_stamina)
		notify_property_list_changed()

@export_range(0, 1) var base_regen_speed: float = 0.5
@export_range(0, 1) var exhausted_regen_speed: float = 0.25
