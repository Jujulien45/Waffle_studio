extends CheckButton


var speed_run_timer: Control 


func _ready() -> void:
	speed_run_timer = get_node("/root/SpeedrunTimer")


func _on_toggled(toggled_on: bool) -> void:
	speed_run_timer.visible = toggled_on
