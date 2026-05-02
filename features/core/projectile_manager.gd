extends Node

class_name ProjectileManager

@export var projectile_scene: PackedScene
@export var _initial_pool_size: int = 10

var _inactive: Array[Projectile] = []
var _active: Array[Projectile] = []

func _ready() -> void:
	for i in range(_initial_pool_size):
		var projectile: Projectile = projectile_scene.instantiate()
		projectile.deactivate()
		
		add_child(projectile)
		_inactive.push_back(projectile)

func advance_frame() -> void:
	for i in range(_active.size() -1, -1, -1):
		var projectile = _active[i]
		
		projectile.advance_frame()
		if projectile.is_deactivated:
			_active.erase(projectile)
			_inactive.push_back(projectile)

func spawn_projectile(req: ProjectileRequest) -> void:
	var projectile: Projectile
	
	if(!_inactive.is_empty()):
		projectile = _inactive.pop_back()
		projectile.activate(req.source, req.fixed_pos_x, req.fixed_pos_y, req.dir_x, req.dir_y)
	else:
		print("No projectiles available, creating one. Active projectiles: ", _active.size())
		
		projectile = projectile_scene.instantiate()
		projectile.activate(req.source, req.fixed_pos_x, req.fixed_pos_y, req.dir_x, req.dir_y)
		
		add_child(projectile)
		
	_active.append(projectile)
