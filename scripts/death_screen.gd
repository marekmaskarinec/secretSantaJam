extends Control

func get_blank_map():
	return {
		"player_name": "player",
		"stones": 0,
		"current_level": "1-1",
		"max_hp": 20,
		"speed": 340,
	}

func _ready():
	get_tree().paused = true
	print($VBoxContainer.rect_size)
	self.rect_position = -$VBoxContainer.rect_size
	get_node("../../Navigation2D").visible = false
	get_node("../../TileMap").visible = false
	$Tween.interpolate_property(self, "modulate", Color(0,0,0,0), Color(0,0,0,1), 6, Tween.TRANS_QUAD, Tween.EASE_OUT)

func save():
	var dict = get_blank_map()
	dict["current_level"] = get_tree().get_root().get_node("pub").level
	
	var save_game = File.new()
	save_game.open("user://" + dict["player_name"] + ".save", File.WRITE)
	save_game.store_string(to_json(dict))
	save_game.close()

func _on_respawnButton_pressed():
	var inst = load("res://scenes/pub.tscn").instance()
	get_tree().get_root().add_child(inst)
	save()
	get_tree().paused = false
	get_tree().get_root().get_node("level").queue_free()
	#get_tree().change_scene("res://scenes/pub.tscn")
