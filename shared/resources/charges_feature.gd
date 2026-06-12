@tool
extends SkillFeature

class_name ChargesFeature

@export var max_charges: int = 1:
	set(value):
		max_charges = max(1, value)
		
		if starting_charges > max_charges:
			starting_charges = max_charges
		
		notify_property_list_changed()

@export var starting_charges: int = 1:
	set(value):
		starting_charges = clampi(value, 0, max_charges)
		notify_property_list_changed()

func get_feature_type() -> StringName:
	return &"charges"
