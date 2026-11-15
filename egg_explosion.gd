extends Node3D
@onready var egg_yolk: GPUParticles3D = $egg_yolk
@onready var egg_shell: GPUParticles3D = $egg_shell
@onready var crack_audio: AudioStreamPlayer3D = $crack

func _ready() -> void:
	crack_audio.play()
	egg_yolk.emitting = true
	egg_shell.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
