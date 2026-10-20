extends Sprite2D

# TODO: better direction indicating sprite
# TODO: handle square sprites not lining up with square collision shapes (sprite sheet and frame swapping?)
@export var character: Character

var _last_character_team: int
var _last_character_dir: Vector2i

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

func _process(_delta: float) -> void:
	if not character.is_active:
		return
	
	var character_team: int = character.team
	if character_team != _last_character_team:
		_last_character_team = character_team
		
		if character_team == DamageSystem.Team.PLAYER:
			self_modulate = GameColors.Team.PLAYER
		elif character_team == DamageSystem.Team.ENEMY:
			self_modulate = GameColors.Team.ENEMY
	
	var character_dir: Vector2i = _last_character_dir # TODO: make this logic part of character (facing dir?)
	if character.atk_dir != Vector2i.ZERO:
		character_dir = character.atk_dir
	elif character.mov_dir != Vector2i.ZERO:
		character_dir = character.mov_dir
	
	if character_dir != _last_character_dir:
		_last_character_dir = character_dir
		
		global_rotation = Vector2(character_dir).angle()
