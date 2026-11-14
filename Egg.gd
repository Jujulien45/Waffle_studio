extends RigidBody3D

const egg_eplosion_scene = preload("res://egg_explosion.tscn")
@onready var ray_cast: RayCast3D = $RayCast3D

func is_on_floor() -> bool:
	return ray_cast.is_colliding()

func _process(delta: float) -> void:
	if is_on_floor():
		var exploding_egg = egg_eplosion_scene.instantiate()
		get_parent().add_child(exploding_egg)
		exploding_egg.global_position = global_position
		queue_free()
