extends Sprite2D

# TODO: directionality
@export var character: Character

func _ready() -> void:
	call_deferred("init")
	
func init() -> void:
	texture = character.character_data.sprite_texture
	if not texture:
		return
	
	var texture_size: Vector2 = texture.get_size()
	
	scale.x = (SGFixed.to_int(character.fp_half_width) * 2) / texture_size.x
	scale.y = (SGFixed.to_int(character.fp_half_height) * 2) / texture_size.y
