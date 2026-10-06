extends Node

class_name InputDisplayUtils

static func get_key_text(debug_name: String, key_bit: int) -> String:
	if not InputConstants.ActionName.FROM_BIT.has(key_bit):
		push_warning("%s: Key bit '%d' not mapped to an action name" % [debug_name, key_bit])
		return "?"
	
	var action_name: StringName = InputConstants.ActionName.FROM_BIT[key_bit]
	if not InputMap.has_action(action_name):
		push_warning("%s: Action name '%s' not recognized" % [debug_name, action_name])
		return "?"
		
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	if events.size() == 0:
		push_warning("%s: Action name '%s' does not have any events" % [debug_name, action_name])
		return "?"
	
	return events[0].as_text_physical_keycode()
