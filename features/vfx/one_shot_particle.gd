extends CPUParticles2D

class_name OneShotParticle

func _ready() -> void:
	finished.connect(_hide)
	visible = true
	restart()
	emitting = true

func play_effect() -> void:
	visible = true
	restart()
	emitting = true

func _hide() -> void:
	visible = false
