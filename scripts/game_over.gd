extends Control

var score = 0
var hi = 0

func _ready():
	var save_game = File.new()
	save_game.open("user://score.save", File.READ)
	hi = int(save_game.get_as_text())
	save_game.close()
	if score > hi:
		#print(hi)
		#print("test")
		hi = score
		save_game.open("user://score.save", File.WRITE)	
		save_game.store_string(str(hi))
		save_game.close()
	
	$CenterContainer/VBoxContainer/Label2.text = "SCORE: " + str(score)
	$CenterContainer/VBoxContainer/Label3.text = "HIGH: " + str(hi)



func _on_respawnButton_pressed():
	Arcade.play()
	queue_free()


func _on_respawnButton2_pressed():
	get_tree().change_scene("res://scenes/pub.tscn")
	queue_free()
