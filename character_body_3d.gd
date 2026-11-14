extends CharacterBody3D


const ACELERATION = 5
const FRICTION = 1
const JUMP_VELOCITY = 4.5

var rotx = 0.0
var roty = 0.0
var ROT = 15
var rot_factor

var paused = false

@export var sensitivity = 0.01

var camera

var MESH: MeshInstance3D

func _ready() -> void:
	MESH = $MeshInstance3D
	camera = $Camera3D
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	rot_factor = ROT / (2 * PI * $MeshInstance3D.mesh.radius)

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
		var cam_basis = camera.transform.basis
		cam_basis.x.y = 0
		cam_basis.z.y = 0
		var direction : Vector3 = (cam_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() #Vector3(input_dir.x * cam_transform_x , 0,  input_dir.y * cam_transform_z).normalized()
		print(direction)
		if direction:
			velocity.x += direction.x * ACELERATION * delta
			velocity.z += direction.z * ACELERATION * delta
		if is_on_floor():
			velocity.x -= FRICTION * velocity.x * delta
			velocity.z -= FRICTION * velocity.z * delta
   
		$MeshInstance3D.rotation -= Vector3(velocity.x, 0, velocity.z) * rot_factor * delta
		"""
		var horizontal_vel := Vector3(velocity.x, 0.0, velocity.z)
		if horizontal_vel.length_squared() > 0.01:
			var target_yaw := atan2(-horizontal_vel.x, -horizontal_vel.z)
			MESH.rotation.y = lerp_angle(MESH.rotation.y, target_yaw, delta * 10.0)
		"""
			
		move_and_slide()

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		var move = event.relative
		rotx -= move.x * sensitivity
		roty -= move.y * sensitivity
		
		roty = max(min(0, roty), -deg_to_rad(89))

	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
		if event.pressed and event.keycode == KEY_P:
			paused = not paused
