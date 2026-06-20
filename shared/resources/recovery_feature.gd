@tool
extends SkillFeature

class_name RecoveryFeature

@export var recovery: int = 0:
	set(value):
		recovery = max(0, value)
		notify_property_list_changed()
