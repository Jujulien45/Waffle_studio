extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play() 
	await get_tree().create_timer(20.0).timeout
	$black.visible = false
	get_node("/root/SpeedrunTimer").stop()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
