class_name RegistryConfig

class Paths:
	const PROJECTILES_CATALOG: String = "res://features/projectiles/catalog"
	const SKILLS_CATALOG: String = "res://features/skills/catalog"
	const VFX_CATALOG: String = "res://features/vfx/catalog"
	const REGISTRY_KEYS: String = "res://core/registry/registry_keys.gd"

class TargetExtensions:
	const RESOURCE_REGISTRY: String = ".tres"
	const SCENE_REGISTRY: String = ".tscn"

# Used by RegistryKeyGenerator
# Parent keys used as-is as auto-generated class names
# path and target_ext for letting the generator know where to scan for what files
const CATALOG_MANIFEST: Dictionary[String, Dictionary] = {
	"Projectiles": {
		"path": Paths.PROJECTILES_CATALOG,
		"target_ext": TargetExtensions.RESOURCE_REGISTRY
	},
	"Skills": {
		"path": Paths.SKILLS_CATALOG,
		"target_ext": TargetExtensions.RESOURCE_REGISTRY
	},
	"VFX": {
		"path": Paths.VFX_CATALOG,
		"target_ext": TargetExtensions.SCENE_REGISTRY
	},
}
