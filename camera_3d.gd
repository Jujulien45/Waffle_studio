extends Camera3D

@export var sensitivity := 0.003
var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var move = event.relative
		rotation.x -= -move.x * sensitivity
		rotation.y -= -move.y * sensitivity
		
		#var player_pos = 
