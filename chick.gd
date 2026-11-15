extends RigidBody3D

@onready var timer: Timer = $Timer
@onready var voicelines: AudioStreamPlayer3D = $voicelines

@export var min_sound_time := 2
@export var max_sound_time := 10
var player: CharacterBody3D

func _ready() -> void:
	schedule_next_sound()
	player = get_tree().get_nodes_in_group("Player")[0]


func schedule_next_sound() -> void:
	timer.wait_time = randi_range(min_sound_time, max_sound_time)
	timer.start()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.add_chick()
		queue_free()


func _on_timer_timeout() -> void:
	if not player.is_playing_audio:
		voicelines.play()
	schedule_next_sound()
