extends Enemy

class_name Wanderer

@export var collision_shape: SGCollisionShape2D

func init(data: EnemyData) -> void:
	super(data)
	
	collision_shape.shape.extents.x = SGFixed.from_int(data.half_width)
	collision_shape.shape.extents.y = SGFixed.from_int(data.half_height)

func advance_frame(_rng: RandomNumberGenerator) -> void:
	# TODO: use rng to determine next action 
	move_and_slide()
