extends Enemy

class_name Wanderer

@export var collision_shape: SGCollisionShape2D

const ANGLES_COUNT: int = 8
const INDEX_SHIFTS: PackedInt32Array = [-1, 1]
const WEIGHT_PENALTY: int = 60

var fp_speed: int

var fp_min_action_duration: int
var fp_max_action_duration: int

var action_ticks: int
var action_rads_index: int
var action_rads_index_shift: int

var fp_rads: Array[int]
#var rads_weights: Array[int]

func init(data: EnemyData) -> void:
	super(data)
	
	collision_shape.shape.extents.x = SGFixed.from_int(data.half_width)
	collision_shape.shape.extents.y = SGFixed.from_int(data.half_height)
	
	fp_speed = data.fp_speed
	fp_min_action_duration = data.fp_min_action_duration
	fp_max_action_duration = data.fp_max_action_duration
	
	action_ticks = 0
	
	var fp_deg: int = 0
	var fp_deg_inc: int = SGFixed.from_int(360 / ANGLES_COUNT)
	for i in range(ANGLES_COUNT):
		fp_rads.append(SGFixed.div(SGFixed.mul(fp_deg, SGFixed.PI), SGFixed.from_int(180)))
		
		fp_deg += fp_deg_inc
	
	#rads_weights.resize(ANGLES_COUNT)

func advance_frame(rng: RandomNumberGenerator) -> void:
	#for i in range(rads_weights.size()):
		#rads_weights[i] = max(rads_weights[i] - 1, 0)
	
	velocity.x = SGFixed.ONE
	velocity.y = 0
	
	if action_ticks > 0:
		action_ticks -= SGFixed.ONE
	else:
		action_ticks = rng.randi_range(fp_min_action_duration, fp_max_action_duration)
		action_rads_index_shift = INDEX_SHIFTS[rng.randi_range(0, 1)]
		
		action_rads_index = rng.randi_range(0, fp_rads.size() - 1)
		
		print("NEW ACTION: %dms" % SGFixed.to_int(action_ticks))
	
	velocity = velocity.rotated(fp_rads[action_rads_index])
	velocity.imul(fp_speed)
	
	move_and_slide()
	
	# TODO: secondary index array for sorting
	# TODO: select movement angle based on sorted index array
	# TODO: handle ties so that it doesn't always default to the same angle
	if get_slide_count() > 0:
		#rads_weights[action_rads_index] += WEIGHT_PENALTY
		
		action_rads_index = posmod(action_rads_index + action_rads_index_shift, fp_rads.size())
		
		print("COLLISION: ", action_rads_index)
