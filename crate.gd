extends RigidBody3D

@export var necessary_speed = 10.0

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body is CharacterBody3D):
		print(body.velocity.length())
		if(body.velocity.length() > necessary_speed and linear_velocity.length() == 0.0):
			linear_velocity = body.velocity
