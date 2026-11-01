@tool
extends Resource

class_name SpriteData

const FRAME_FROM_DIRECTION: Dictionary[Vector2i, int] = {
	Vector2i.RIGHT: 0,
	Vector2i(1, -1): 1,
	Vector2i.UP: 2,
	Vector2i(-1, -1): 3,
	Vector2i.LEFT: 4,
	Vector2i(-1, 1): 5,
	Vector2i.DOWN: 6,
	Vector2i(1, 1): 7,
}

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
