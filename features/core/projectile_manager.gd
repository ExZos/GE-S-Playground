extends Node

# TODO: consider using signals in other places
class_name ProjectileManager

@export var projectile_scene: PackedScene

var _inactive: Array[Projectile] = []
var _active: Array[Projectile] = []

var _initial_count: int = 10

func _ready() -> void:
	for i in range(_initial_count):
		_inactive.push_back(_create_projectile())
		
func _create_projectile() -> Projectile:
	var projectile: Projectile = projectile_scene.instantiate()
	
	projectile.deactivate()
	projectile.deactivated.connect(_on_projectile_deactivated)
	
	add_child(projectile)
	return projectile

func _on_projectile_deactivated(projectile: Projectile) -> void:
	_active.erase(projectile)
	_inactive.push_back(projectile)
	
func spawn_projectile(source: Node2D, fixed_pos_x: int, fixed_pos_y: int, dir_x: int, dir_y: int) -> void:
	var projectile: Projectile
	
	if(!_inactive.is_empty()):
		projectile = _inactive.pop_back()
	else:
		print("No projectiles available, creating one. Active projectile: ", _active.size())
		projectile = _create_projectile()
		
	projectile.activate(source, fixed_pos_x, fixed_pos_y, dir_x, dir_y)
	_active.append(projectile)
