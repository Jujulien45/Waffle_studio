extends StaticBody3D

const floor_eplosion_scene = preload("res://floor_explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body is CharacterBody3D):
		if(body.ground_pound):
			var exploding_floor = floor_eplosion_scene.instantiate()
			get_parent().add_child(exploding_floor)
			exploding_floor.global_position = global_position
			queue_free()
