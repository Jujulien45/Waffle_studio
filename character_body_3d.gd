extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var rotx = 0.0
var roty = 0.0

var paused = false

@export var sensitivity = 0.01

var camera

func _ready() -> void:
	camera = $Camera3D
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	
	if(not paused):
	
		$Camera3D.rotation = Vector3(roty,rotx,0.0)
		$Camera3D.position = Vector3(0,0,4).rotated(Vector3(1,0,0),roty).rotated(Vector3(0,1,0),rotx)
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction : Vector3 = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() #Vector3(input_dir.x * cam_transform_x , 0,  input_dir.y * cam_transform_z).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
   
		move_and_slide()

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		var move = event.relative
		rotx -= move.x * sensitivity
		roty -= move.y * sensitivity
		
		roty = max(min(0, roty), -PI/2)

	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
		if event.pressed and event.keycode == KEY_P:
			paused = not paused
