extends Node2D

var slow_mo = 10
var first_press = true
var start
var tween

func _ready():
	tween = get_node("player/Camera2D/UI/UiTween")
	

func _process(delta):
	if Input.is_action_pressed("slow_motion") and slow_mo > 0:
		if first_press:
			start = OS.get_datetime()["second"]
			first_press = false
		if OS.get_datetime()["second"] - start >= 1 or OS.get_datetime()["second"] - start < 0:
			slow_mo -= 1
			start = OS.get_datetime()["second"]
			tween.interpolate_property(get_node("player/Camera2D/UI/VBoxContainer/slow_mo_progress"), "value",
				get_node("player/Camera2D/UI/VBoxContainer/slow_mo_progress").value, slow_mo, 1,
				Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()


		Engine.time_scale = 0.2
	else:
		Engine.time_scale = 1
		first_press = true
