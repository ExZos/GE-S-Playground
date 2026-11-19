extends Node

class_name GameplayRegistry

# TODO: smaller registry that is autoloaded for scene swapping
@export var projectile_registry: ProjectileRegistry
@export var skill_registry: SkillRegistry
@export var player_registry: PlayerRegistry
@export var enemy_registry: EnemyRegistry
@export var wave_registry: WaveRegistry
@export var vfx_registry: VFXRegistry # TODO: AssetRegistry

static var current: GameplayRegistry

func _enter_tree() -> void:
	current = self

func _exit_tree() -> void:
	if current == self:
		current = null

func init() -> void:
	projectile_registry.init()
	skill_registry.init()
	player_registry.init()
	enemy_registry.init()
	wave_registry.init()
	vfx_registry.init()

func get_projectile_data(type: StringName) -> ProjectileData:
	return projectile_registry.get_data(type)

func get_skill_data(type: StringName) -> SkillData:
	return skill_registry.get_data(type)

func get_player_data(type: StringName) -> PlayerData:
	return player_registry.get_data(type)

func get_enemy_data(type: StringName) -> EnemyData:
	return enemy_registry.get_data(type)
	
func get_wave_data(type: StringName) -> WaveData:
	return wave_registry.get_data(type)

func get_vfx_scene(type: StringName) -> PackedScene:
	return vfx_registry.get_scene(type)
