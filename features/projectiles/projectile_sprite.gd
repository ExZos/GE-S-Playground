extends Sprite2D

@export_custom(PROPERTY_HINT_NODE_TYPE, "SensorProjectile,SolidProjectile") var projectile: Node2D

var _last_projectile_team: int

func _ready() -> void:
	call_deferred("init")

func init() -> void:
	assert(projectile, "ProjectileSprite: Projectile must be assigned")
	
	var projectile_data: ProjectileData = RegistryManager.projectile_registry.get_data(projectile.type)
	texture = projectile_data.sprite_texture
	if not texture:
		return
	
	var texture_size: Vector2 = texture.get_size()
	scale.x = (projectile_data.half_width * 2) / texture_size.x
	scale.y = (projectile_data.half_height * 2) / texture_size.y

func _process(_delta: float) -> void:
	if not projectile.is_active:
		return
	
	var projectile_team: int = projectile.source.team
	
	if projectile_team != _last_projectile_team:
		_last_projectile_team = projectile_team
		
		if projectile_team == DamageSystem.Team.PLAYER:
			self_modulate = Color.LIGHT_BLUE
		elif projectile_team == DamageSystem.Team.ENEMY:
			self_modulate = Color.LIGHT_SALMON
