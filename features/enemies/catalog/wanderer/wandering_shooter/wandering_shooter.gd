extends Wanderer

class_name WanderingShooter

# TODO: put this into the resource
var shoot_skill_type: StringName = &"shoot_sensor"
var shoot_skill: ShootSkill

var special_action_ticks: int

func init(data: EnemyData) -> void:
	super(data)
	
	# TODO: go through registry instead
	var shoot_skill_data: SkillData = RegistryManager.get_skill_data(shoot_skill_type)
	
	shoot_skill = shoot_skill_data.scene.instantiate()
	shoot_skill.init(self, 0, shoot_skill_data)
	
	add_child(shoot_skill)
	
	special_action_ticks = 0

func advance_frame(rng: RandomNumberGenerator) -> void:
	super(rng)
	
	if special_action_ticks > 0:
		special_action_ticks -= SGFixed.ONE

func _special_action() -> void:
	if special_action_ticks > 0:
		return
	
	print("WanderingShooter: SHOOT")
	shoot_skill._on_activate(Vector2i.ZERO, Vector2i.RIGHT)
	special_action_ticks = shoot_skill._fp_cooldown
