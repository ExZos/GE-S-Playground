@tool
extends Resource

class_name SpriteData

@export var texture: Texture2D

@export var row_frame_counts: PackedInt32Array:
	set(value):
		row_frame_counts = value
		
		# Determine vframes
		vframes = value.size()
		
		# Determine hframes
		hframes = 0
		for frame_count: int in value:
			if frame_count > hframes:
				hframes = frame_count

var vframes: int
var hframes: int
