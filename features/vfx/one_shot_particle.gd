extends CPUParticles2D

class_name OneShotParticle

func _ready() -> void:
	finished.connect(deactivate)

func activate() -> void:
	visible = true
	emitting = true
	
	restart()

func deactivate() -> void:
	visible = false
	emitting = false
