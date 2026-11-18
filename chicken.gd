@tool
extends Node3D

var chick_scene = preload("res://Chick.tscn")
var male_chick = preload("res://male_chick.tscn")


func _ready() -> void:
	var instance
	if Engine.is_editor_hint():
		instance = chick_scene.instantiate()
	else:
		if randi_range(0, 9) == 0:
			instance = male_chick.instantiate()
		else:
			instance = chick_scene.instantiate()
	
	add_child(instance)
	rotation_degrees.y = randi_range(0, 360)
