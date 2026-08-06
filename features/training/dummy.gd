extends SGStaticBody2D

# TODO: health UI
class_name Dummy

@export var collision_shape: SGCollisionShape2D
@export var damageable: Damageable

@export var max_hp: int
@export var respawn_time: int

var respawn_ticker: int

func init() -> void:
	damageable.init(max_hp)

func advance_frame() -> void:
	if respawn_ticker > 0:
		respawn_ticker -= 1
		
		if respawn_ticker <= 0:
			reset()

func take_damage(damage: int) -> void:
	damageable.take_damage(damage)
	
	if damageable.is_dead:
		on_death()

func on_death() -> void:
	set_physics_process(false)
	collision_shape.disabled = true
	hide()
	
	respawn_ticker = respawn_time
	
	sync_to_physics_engine()

func reset() -> void:
	damageable.reset()
	
	set_physics_process(true)
	collision_shape.disabled = false
	show()
	
	sync_to_physics_engine()
