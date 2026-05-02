extends Node

@export var inputManager: InputManager
@export var player: Player
@export var projectileManager: ProjectileManager

func _physics_process(_delta: float) -> void:
	var input_mask: int = inputManager.get_input_mask()
	player.advance_frame(input_mask)
	
	if(player._projectile_request):
		projectileManager.spawn_projectile(player._projectile_request)
		player._projectile_request = null
	
	projectileManager.advance_frame()
