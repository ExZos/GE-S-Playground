extends CPUParticles2D

class_name OneShotParticle

var is_active: bool = false

func _ready() -> void:
	finished.connect(deactivate)

func activate() -> void:
	is_active = true
	
	visible = true
	emitting = true
	
	restart()

func deactivate() -> void:
	is_active = false
	
	visible = false
	emitting = false
