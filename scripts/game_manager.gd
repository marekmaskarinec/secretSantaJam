extends Node2D

func _process(delta):
	if Input.is_action_pressed("slow_motion"):
		Engine.time_scale = 0.2
	else:
		Engine.time_scale = 1
