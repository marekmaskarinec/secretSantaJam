extends Node

var volume = 50
var fullscreen = false

func _ready():
	load_settings()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	OS.window_fullscreen = fullscreen

func load_settings():
	var save_game = File.new()
	save_game.open("user://settings.save", File.READ)
	var dat = parse_json(save_game.get_as_text())
	save_game.close()
	
	if dat != null:
		volume = dat["vol"]
		fullscreen = dat["fullscreen"]
	else:
		volume = -10
		fullscreen = false

func save():
	var save_game = File.new()
	save_game.open("user://settings.save", File.WRITE)
	var dict = {
		"vol": volume,
		"fullscreen": fullscreen,
	}
	save_game.store_string(to_json(dict))
	save_game.close()


func set_volume(num):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), num)
	volume = num
	save()

func set_fullscreen(choice):
	OS.window_fullscreen = choice
	fullscreen = choice
	save()
