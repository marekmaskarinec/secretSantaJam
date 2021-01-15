extends Node2D

var slow_mo = 10
var first_press = true
var start
var tween

func _ready():
	tween = get_node("player/Camera2D/UI/UiTween")
	

func _process(_delta):
	#slow_mo = sget_node("player/Camera2D/UI/VBoxContainer/slow_mo_progress").value
	if false:#Input.is_action_pressed("slow_motion") and slow_mo > 0:
		if first_press:
			first_press = false
			tween.interpolate_property(get_node("player/Camera2D/UI/VBoxContainer/slow_mo_progress"), "value",
				get_node("player/Camera2D/UI/VBoxContainer/slow_mo_progress").value, 0, slow_mo/320,
				Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()

		Engine.time_scale = 0.2
	elif false:
		tween.stop_all()
		if first_press == false:
			print("recharging")
			tween.interpolate_property(get_node("player/Camera2D/UI/VBoxContainer/slow_mo_progress"), "value",
				slow_mo, 100, 0.04,#(100-slow_mo)/320,
				Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()
		Engine.time_scale = 1
		first_press = true
		
