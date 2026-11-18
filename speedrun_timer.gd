extends Control

var start_time: int = 0.0
var elapsed_time_s: float = 0.0

var paused: bool = false
var elapsed_pause_time: int = 0.0
var pause_start: int = 0.0

@export var running: bool = false

@onready var time_label = $time
@onready var ms_label = $time/miliseconds


func _ready() -> void:
	time_label.text = format_time(elapsed_time_s)
	ms_label.text = format_ms(elapsed_time_s)


func _process(delta: float) -> void:
	if running:
		update_time()


func update_time():
	elapsed_time_s = get_elapsed_time()
	time_label.text = format_time(elapsed_time_s)
	ms_label.text = format_ms(elapsed_time_s)


func format_ms(seconds):
	return ".%03d" % [int(seconds * 1000) % 1000, ]

func format_time(time_s: float) -> String:
	var s: int = int(time_s) % 60
	var m: int = int(time_s / 60)
	var h: int = int(time_s / 3600)
	
	return "%02d:%02d:%02d" % [h, m, s]
	
func start():
	start_time = Time.get_ticks_usec()
	elapsed_time_s = 0.0
	running = true
	elapsed_pause_time = 0.0
	pause_start = 0.0

func pause() -> void:
	pause_start = Time.get_ticks_usec()
	paused = true

func unpause() -> void:
	paused = false
	elapsed_pause_time += Time.get_ticks_usec() - pause_start

func toggle_pause() -> void:
	if paused:
		unpause()
	else:
		pause()


func stop():
	running = false

func get_elapsed_time() -> float:
	var now = Time.get_ticks_usec()

	if paused:
		return elapsed_time_s
	else:
		return (now - start_time - elapsed_pause_time) / 1_000_000.0
	
