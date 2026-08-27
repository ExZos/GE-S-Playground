extends Enemy

class_name Wanderer

@export var collision_shape: SGCollisionShape2D

var fp_speed: int

var fp_min_action_duration: int
var fp_max_action_duration: int

var action_ticks: int

func init(data: EnemyData) -> void:
	super(data)
	
	collision_shape.shape.extents.x = SGFixed.from_int(data.half_width)
	collision_shape.shape.extents.y = SGFixed.from_int(data.half_height)
	
	fp_speed = data.fp_speed
	fp_min_action_duration = data.fp_min_action_duration
	fp_max_action_duration = data.fp_max_action_duration
	
	action_ticks = 0

func advance_frame(rng: RandomNumberGenerator) -> void:
	if action_ticks > 0:
		action_ticks -= SGFixed.ONE
	else:
		action_ticks = rng.randi_range(fp_min_action_duration, fp_max_action_duration)
		
		# TODO: pick from available directions to prevent repeated collisions
		# TODO: change direction on collision (maybe except with player)
		# TODO: consider preventing no movement actions
		velocity.x = fp_speed * randi_range(-1, 1)
		velocity.y = fp_speed * randi_range(-1, 1)
		
		print("NEW ACTION: %dms" % SGFixed.to_int(action_ticks))
	
	move_and_slide()
