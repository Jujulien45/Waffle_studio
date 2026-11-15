extends Node3D
@onready var wood: GPUParticles3D = $wood
@onready var wood_big: GPUParticles3D = $wood_big

func _ready() -> void:
	wood.emitting = true
	wood_big.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
