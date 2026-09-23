extends Wanderer

class_name WanderingShooter

# TODO: put this into the resource
var fp_special_action_cooldown: int = SGFixed.from_int(90)

var special_action_ticks: int

func init(data: EnemyData) -> void:
	super(data)
	
	special_action_ticks = 0

func advance_frame(rng: RandomNumberGenerator) -> void:
	super(rng)
	
	if special_action_ticks > 0:
		special_action_ticks -= SGFixed.ONE

func _special_action() -> void:
	if special_action_ticks > 0:
		return
	
	print("WanderingShooter: SHOOT")
	special_action_ticks = fp_special_action_cooldown
