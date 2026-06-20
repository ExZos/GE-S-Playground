extends Node

@export var projectile_registry: ProjectileRegistry
@export var skill_registry: SkillRegistry
@export var vfx_registry: VFXRegistry # TODO: AssetRegistry

func init() -> void:
	projectile_registry.init()
	skill_registry.init()
	vfx_registry.init()

func get_projectile_data(type: StringName) -> ProjectileData:
	return projectile_registry.get_data(type)

func get_skill_data(type: StringName) -> SkillData:
	return skill_registry.get_data(type)

func get_vfx_scene(type: StringName) -> PackedScene:
	return vfx_registry.get_scene(type)
