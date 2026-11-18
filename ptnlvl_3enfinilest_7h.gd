extends Node3D

var start

@onready var tuto = $Player/CanvasLayer/Control/tuto

func _ready() -> void:
	tuto.text = "Press CTRL to groundpound"
	start = Time.get_ticks_msec()
	
func _process(_delta) -> void :
	if(tuto.text != ""):
		if(Time.get_ticks_msec() > 5000 + start):
			tuto.text = ""

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body is CharacterBody3D):
		get_tree().change_scene_to_file("res://ending.tscn")
