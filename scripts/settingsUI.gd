extends Control

func _ready():
	update()

func update():
	$VBoxContainer/CenterContainer/HBoxContainer/Label.text = "VOLUME: " + str((Settings.volume+50)*2)
	var tmp = {
		true: "ON",
		false: "OFF",
	}
	$VBoxContainer/minus2.text = "FULLSCREEN: " + tmp[Settings.fullscreen]


func _on_minus_pressed():
	if Settings.volume >= -50:
		Settings.set_volume(Settings.volume-5)
		update()

func _on_plus_pressed():
	if Settings.volume <= 0:
		Settings.set_volume(Settings.volume+5)
		update()
		


func _on_minus2_toggled(button_pressed):
	Settings.set_fullscreen(button_pressed)
	update()
