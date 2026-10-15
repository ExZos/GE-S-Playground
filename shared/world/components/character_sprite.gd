extends Sprite2D

# TODO: directionality
@export var character: Character

var _last_character_team: int

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
