extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$Button.queue_free()
	$TextureRect.texture = load("res://assets/pictures/chad.png")
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			get_tree().change_scene_to_file("res://barnlv1.tscn")
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
