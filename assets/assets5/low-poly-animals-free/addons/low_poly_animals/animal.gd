extends Node
## An animal's day, on the animal's scene it is a child of: it looks about, wanders round its
## `home`, eats, lies down to sleep and gets up again, and runs from `threat` when it comes within
## `shy` metres. The clips play on the scene's own AnimationPlayer; it walks and runs at
## `walk_speed` and `run_speed`, the paces its clips' feet keep (the meadow's "speeds").

@export var home := Vector3.ZERO
@export var radius := 5.0
@export var walk_speed := 1.0
@export var run_speed := 4.0
@export var shy := 6.0
@export var threat: Node3D
@export var turn_speed := 3.0  # radians a second

var state := ""  # idle, walk, eat, lie_down, sleep, stand_up, rouse (getting up to run) or flee
var left := 0.0  # seconds this state has to go
var goal := Vector3.ZERO
var nap := 0.0  # seconds the sleep `rest` asked for
var animal: Node3D
var player: AnimationPlayer
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	animal = get_parent()
	player = animal.find_child("AnimationPlayer", true, false)
	player.animation_finished.connect(_finished)
	rng.seed = hash(animal.position)
	_idle()
	left = rng.randf_range(0.0, 4.0)


func _physics_process(delta: float) -> void:
	left -= delta
	var near := _from_threat()
	if near < shy and state not in ["flee", "rouse"]:
		if state in ["lie_down", "sleep", "stand_up"]:
			_play("rouse", "stand_up", 2.0)
		else:
			_flee()
	match state:
		"walk":
			var to := goal - animal.position
			to.y = 0.0
			if to.length() < 0.3 or left <= 0.0:
				_idle()
			else:
				_go(to, walk_speed, delta)
		"flee":
			var away := animal.position - threat.position if is_instance_valid(threat) else Vector3.ZERO
			var back := home - animal.position
			away.y = 0.0
			back.y = 0.0
			var pull := clampf(back.length() / (2.5 * radius) - 1.0, 0.0, 2.0)  # kept to its ground
			_go(away.normalized() + back.normalized() * pull, run_speed, delta)
			if near > 2.0 * shy and left <= 0.0:
				_idle()
		"idle", "eat":
			if left <= 0.0:
				_next()
		"sleep":
			if left <= 0.0:
				_play("stand_up", "stand_up")


## Lies down now and sleeps `seconds`.
func rest(seconds := 0.0) -> void:
	_play("lie_down", "lie_down")
	nap = seconds


func _next() -> void:
	var r := rng.randf()
	if r < 0.45:
		var a := rng.randf() * TAU
		goal = home + Vector3(cos(a), 0, sin(a)) * radius * sqrt(rng.randf())
		_play("walk", "walk")
		left = 4.0 * radius / walk_speed
	elif r < 0.82:
		_play("eat", "eat")
		left = rng.randf_range(6.0, 14.0)
	else:
		rest()


func _idle() -> void:
	_play("idle", "idle")
	left = rng.randf_range(2.0, 5.0)


func _flee() -> void:
	_play("flee", "run")
	left = 2.0


func _play(to: String, clip: String, speed := 1.0) -> void:
	state = to
	player.play(clip, 0.25, speed)


func _finished(clip: StringName) -> void:
	match state:
		"lie_down":
			_play("sleep", "sleep")
			left = nap if nap > 0.0 else rng.randf_range(10.0, 25.0)
			nap = 0.0
		"stand_up":
			_idle()
		"rouse":
			_flee()


## Turned toward `to` at its turn speed and moved forward (+Z) `speed`.
func _go(to: Vector3, speed: float, delta: float) -> void:
	if to.length() > 0.01:
		animal.rotation.y = rotate_toward(animal.rotation.y, atan2(to.x, to.z), turn_speed * delta)
	animal.position += animal.basis.z * speed * delta


func _from_threat() -> float:
	if not is_instance_valid(threat):
		return INF
	var d := threat.global_position - animal.global_position
	d.y = 0.0
	return d.length()
