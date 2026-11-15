extends Node3D

var start

func _ready() -> void:
	$Player/CanvasLayer/tuto.text = "Press CTRL to groundpound"
	start = Time.get_ticks_msec()
	
func _process(_delta) -> void :
	if($Player/CanvasLayer/tuto.text != ""):
		if(Time.get_ticks_msec() > 5000 + start):
			$Player/CanvasLayer/tuto.text = ""

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body is CharacterBody3D):
		get_tree().change_scene_to_file("res://ending.tscn")
