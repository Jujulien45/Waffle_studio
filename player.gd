extends CharacterBody3D

var egg = preload("res://egg.tscn")

const ACELERATION = 5
const DASH_ACCEL =  20
const FRICTION = 0.4  
const JUMP_VELOCITY = 7

var rotx = 0.0
var roty = 0.0

var radius

var double_jumped = false
var dir = null

var ground_pound = false

var dash_time = -5000
var dash_available = true

var pred_speed = null

var paused = false

@export var sensitivity = 0.01


var camera

# On remplace la caméra par le Pivot
@onready var pivot = $PivotCamera 
@onready var cast  = $RayCast3D

var MESH: MeshInstance3D
var Pickup_steam_player: AudioStreamPlayer3D
var lay_egg_steam_player: AudioStreamPlayer3D
var jump_stream_player: AudioStreamPlayer3D
var voicelines_audio: AudioStreamPlayer3D

var is_playing_audio := false

func _ready() -> void:
	jump_stream_player = $jump
	Pickup_steam_player = $pickup
	lay_egg_steam_player = $lay_egg
	MESH = $MeshInstance3D
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	radius = $MeshInstance3D.mesh.radius
	voicelines_audio = $voicelines

func _physics_process(delta: float) -> void:
	
	if(not paused):
		# On applique la rotation au Pivot au lieu de la caméra
		pivot.rotation = Vector3(roty, rotx, 0.0)
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		if is_on_floor():
			velocity += get_gravity().slide(get_floor_normal()) * delta
			double_jumped = false
			ground_pound = false

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and double_jumped == false:
			velocity.y = JUMP_VELOCITY
			if(not is_on_floor()):
				lay_egg_steam_player.play()
				double_jumped = true
				var egg_inst = egg.instantiate()
				get_parent().add_child(egg_inst)
				egg_inst.global_position = global_position
				egg_inst.global_position.y -= 0.6
			else:
				jump_stream_player.play()

		# Get the input direction
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		# On utilise le basis du Pivot pour les déplacements
		var cam_basis = pivot.transform.basis
		cam_basis.x.y = 0
		cam_basis.z.y = 0
		cam_basis.y.x = 0
		cam_basis.y.z = 0
		
		var direction : Vector3 = (cam_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		dir = direction
		if direction:
			velocity.x += direction.x * ACELERATION * delta
			velocity.z += direction.z * ACELERATION * delta
		if is_on_floor():
			velocity.x -= FRICTION * velocity.x * delta
			velocity.z -= FRICTION * velocity.z * delta
   
		# Logique de roulement du coq (inchangée)
		var v := velocity
		v.y = 0.0
		var axis := Vector3.UP.cross(v).normalized()
		var angle : float = v.length() / radius * delta

		var local_axis := global_transform.basis.inverse() * axis
		MESH.basis = MESH.basis.rotated(local_axis.normalized(), angle)
			
		move_and_slide()
		
		pred_speed = velocity
		
		if(not dash_available):
			if(Time.get_ticks_msec() > 4000 + dash_time):
				dash_available = true

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		var move = event.relative
		rotx -= move.x * sensitivity
		roty -= move.y * sensitivity
		
		# On limite la rotation verticale pour ne pas se retourner
		roty = max(min(0, roty), -deg_to_rad(89))

	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
		if event.pressed and event.keycode == KEY_P:
			paused = not paused
		if event.pressed and event.keycode == KEY_E and not paused:
			if(dir and dash_available):
				velocity.x += dir.x * DASH_ACCEL
				velocity.z += dir.z * DASH_ACCEL
				dash_time = Time.get_ticks_msec()
				dash_available = false
		if event.pressed and event.keycode == KEY_CTRL and not ground_pound and not paused:
			ground_pound = true
			velocity.y -= 5*JUMP_VELOCITY

func add_chick():
	is_playing_audio = true
	Pickup_steam_player.play()


func _on_pickup_finished() -> void:
	voicelines_audio.play()


func _on_voicelines_finished() -> void:
	is_playing_audio = false
