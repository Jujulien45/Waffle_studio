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


@onready var progress_bar : ProgressBar = $CanvasLayer/Control/ProgressBar
@onready var progress_label : Label = $CanvasLayer/Control/Progress_label
@onready var warning_label : Label = $CanvasLayer/Control/Warning
var total_chicks : int = 0
var picked_up_chicks : int = 0
var has_all_chicks: bool = false

var MESH: Node3D
var Pickup_steam_player: AudioStreamPlayer3D
var lay_egg_steam_player: AudioStreamPlayer3D
var jump_stream_player: AudioStreamPlayer3D
var voicelines_audio: AudioStreamPlayer3D
@onready var jump_sound_delay: Timer = $jump_sound_delay
@export var JUMP_SOUND_DELAY := 0.2

var is_playing_audio := false

var warning = false
@onready var warning_blink: Timer = $warning_blink
@onready var warning_timer: Timer = $warning_timer
@export var WARNING_BLINK_DELAY = 0.5
@export var WARNING_DURATION = 5

var num_sounds_playing = 0


func _ready() -> void:
	jump_stream_player = $jump
	Pickup_steam_player = $pickup
	lay_egg_steam_player = $lay_egg
	MESH = $ChickenBrown
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	radius = $CollisionShape3D.shape.radius
	voicelines_audio = $voicelines
	
	progress_label.text = "0/" + str(total_chicks)
	progress_bar.max_value = total_chicks
	progress_bar.value = 0
	
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
				jump_sound_delay.wait_time = JUMP_SOUND_DELAY
				jump_sound_delay.start()
				double_jumped = true
				var egg_inst = egg.instantiate()
				get_parent().add_child(egg_inst)
				egg_inst.global_position = global_position
				egg_inst.global_position.y -= 0.6
				
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
			$CanvasLayer/Pause.visible = not $CanvasLayer/Pause.visible
		if event.pressed and event.keycode == KEY_E and not paused:
			if(dir and dash_available):
				velocity.x += dir.x * DASH_ACCEL
				velocity.z += dir.z * DASH_ACCEL
				dash_time = Time.get_ticks_msec()
				dash_available = false
		if event.pressed and event.keycode == KEY_CTRL and not ground_pound and not paused:
			ground_pound = true
			velocity.y -= 5*JUMP_VELOCITY


func _process(_delta: float) -> void:
	if not paused:
		picked_up_chicks = total_chicks - get_tree().get_node_count_in_group("Chicken")
		progress_label.text = str(picked_up_chicks) + "/" + str(total_chicks)
		progress_bar.value = picked_up_chicks
		progress_bar.max_value = total_chicks

		if picked_up_chicks >= total_chicks:
			has_all_chicks = true
		else:
			has_all_chicks = false

func play_sound(sound: AudioStreamPlayer3D, ignore_cap = false) -> void:
	if num_sounds_playing < 4 or ignore_cap:
		num_sounds_playing += 1
		sound.play()
		sound.finished.connect(_on_audio_finished.bind(sound), CONNECT_ONE_SHOT)

func _on_audio_finished(sound: AudioStreamPlayer3D) -> void:
	num_sounds_playing = 0

func pick_up_chick():
	is_playing_audio = true
	play_sound(Pickup_steam_player, true)


func add_chick():
	total_chicks += 1


func start_warning() -> void:
	warning_timer.wait_time = WARNING_DURATION
	warning_timer.start()
	warning = true
	warning_label.visible = true

func _on_pickup_finished() -> void:
	play_sound(voicelines_audio, true)


func _on_voicelines_finished() -> void:
	is_playing_audio = false


func _on_warning_timer_timeout() -> void:
	warning = false
	warning_label.visible = false


func _on_jump_sound_delay_timeout() -> void:
	play_sound(jump_stream_player, true)
	
