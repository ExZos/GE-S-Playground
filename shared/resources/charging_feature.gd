@tool
extends SkillFeature

class_name ChargingFeature

@export var charge_time: int = 60:
	set(value):
		charge_time = max(0, value)
		notify_property_list_changed()
