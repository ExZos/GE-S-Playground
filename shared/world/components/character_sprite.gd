extends Sprite2D

# TODO: directionality
@export var character: Character

func _ready() -> void:
	call_deferred("init")
	
func init() -> void:
	assert(character, "CharacterSprite: Character must be assigned")
	
	var character_data: CharacterData = character.character_data
	texture = character_data.sprite_texture
	if not texture:
		return
	
	var texture_size: Vector2 = texture.get_size()
	scale.x = (character_data.half_width * 2) / texture_size.x
	scale.y = (character_data.half_height * 2) / texture_size.y
