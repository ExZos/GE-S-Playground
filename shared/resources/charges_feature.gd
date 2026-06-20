@tool
extends SkillFeature

class_name ChargesFeature

@export var max_charges: int = 1:
	set(value):
		max_charges = max(1, value)
		
		if starting_charges > max_charges:
			starting_charges = max_charges
		
		if charges_inc > max_charges:
			charges_inc = max_charges
		
		notify_property_list_changed()

@export var starting_charges: int = 1:
	set(value):
		starting_charges = clampi(value, 0, max_charges)
		notify_property_list_changed()

@export var charges_inc: int = 1:
	set(value):
		charges_inc = clampi(value, 1, max_charges)
		notify_property_list_changed()
