extends "res://addons/low_poly_animals/demo/gallery.gd"
## The pack's gallery with its meadow alive: shown (L) or on foot (W), each animal goes about its day
## round its home (the layout's `homes`) with animal.gd on it, and runs from you.

const Animal := preload("res://addons/low_poly_animals/animal.gd")

var animals: Array = []  # the meadow's, animal.gd each


func show_level(plan := true) -> void:
	super.show_level(plan)
	animals = []
	var speeds: Dictionary = level.get("speeds", {})
	for home in level.get("homes", []):
		var n: Node3D = shown.get_child(home[0])
		var s: Array = speeds[n.get_meta("prop")["name"]]
		var a := Animal.new()
		a.home = n.position
		a.radius = home[1]
		a.walk_speed = s[0]
		a.run_speed = s[1]
		a.shy = 4.0 + s[1]  # the quicker, the warier
		n.add_child(a)
		animals.append(a)


func _on_foot(at: Vector3, turn: float) -> void:
	super._on_foot(at, turn)
	for a in animals:
		a.threat = walker
