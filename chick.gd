extends RigidBody3D


var gender := "female" 

func _ready() -> void:
	if randi_range(0, 9) == 0:
		gender = "male"


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.add_chick()
		queue_free()
