extends Node3D


var player: CharacterBody3D

var start

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	$Player/CanvasLayer/tuto.text = "Press E to dash"
	start = Time.get_ticks_msec()
	
func _process(_delta) -> void :
	if($Player/CanvasLayer/tuto.text != ""):
		if(Time.get_ticks_msec() > 5000 + start):
			$Player/CanvasLayer/tuto.text = ""
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body is CharacterBody3D):
		if player.has_all_chicks:
			get_tree().change_scene_to_file("res://lv_3 ... .tscn")
		else:
			player.start_warning()
