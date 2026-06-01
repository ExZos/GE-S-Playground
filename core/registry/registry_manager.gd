extends Node

@export var projectile_registry: ProjectileRegistry
@export var skill_registry: SkillRegistry
@export var vfx_registry: VFXRegistry

func init() -> void:
	projectile_registry.init()
	skill_registry.init()
	vfx_registry.init()

func get_projectile_data(type: ProjectileData.Type) -> ProjectileData:
	return projectile_registry.get_data(type)

func get_skill_data(type: SkillData.Type) -> SkillData:
	return skill_registry.get_data(type)

func get_vfx_data(type: VFXData.Type) -> VFXData:
	return vfx_registry.get_data(type)
