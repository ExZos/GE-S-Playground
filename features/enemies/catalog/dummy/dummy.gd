extends Enemy

class_name Dummy

@export var collision_shape: SGCollisionShape2D

func init(data: EnemyData) -> void:
	super(data)
	
	collision_shape.shape.extents.x = SGFixed.from_int(data.width / 2)
	collision_shape.shape.extents.y = SGFixed.from_int(data.height / 2)

func advance_frame() -> void:
	move_and_slide()
