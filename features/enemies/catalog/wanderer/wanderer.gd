extends Enemy

class_name Wanderer

@export var collision_shape: SGCollisionShape2D

const ANGLES_COUNT: int = 8

var fp_speed: int

var fp_min_action_duration: int
var fp_max_action_duration: int

var action_ticks: int
var action_angle_index: int

var fp_rads: Array[int]
var angle_weights: Array[int]

func init(data: EnemyData) -> void:
	super(data)
	
	collision_shape.shape.extents.x = SGFixed.from_int(data.half_width)
	collision_shape.shape.extents.y = SGFixed.from_int(data.half_height)
	
	fp_speed = data.fp_speed
	fp_min_action_duration = data.fp_min_action_duration
	fp_max_action_duration = data.fp_max_action_duration
	
	action_ticks = 0
	
	var fp_degrees: int = 0
	var fp_degrees_inc: int = SGFixed.from_int(360 / ANGLES_COUNT)
	for i in range(ANGLES_COUNT):
		fp_rads.append(SGFixed.div(SGFixed.mul(fp_degrees, SGFixed.PI), SGFixed.from_int(180)))
		print(fp_rads[i])
		
		fp_degrees += fp_degrees_inc
	
	angle_weights.resize(ANGLES_COUNT)

func advance_frame(rng: RandomNumberGenerator) -> void:
	velocity.x = SGFixed.ONE
	velocity.y = 0
	
	if action_ticks > 0:
		action_ticks -= SGFixed.ONE
	else:
		action_ticks = rng.randi_range(fp_min_action_duration, fp_max_action_duration)
		
		# TODO: pick from available directions to prevent repeated collisions
		# TODO: test angles with test_move
		# TODO: secondary index array for sorting?
		# TODO: change direction on collision (maybe except with player)
		action_angle_index = rng.randi_range(0, ANGLES_COUNT - 1)
		
		print("NEW ACTION: %dms" % SGFixed.to_int(action_ticks))
	
	velocity = velocity.rotated(fp_rads[action_angle_index])
	velocity.imul(fp_speed)
	
	move_and_slide()
