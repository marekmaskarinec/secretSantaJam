extends Node2D

var level = "1-1"
var levels = ["1-1", "1-2", "1-3", "1-4", "1-5", "2-1", "2-2", "2-3", "2-4", "2-5", "1-1"]
var start = true

func _ready():
	if start:
		load_game()
	else:
		level = levels[levels.bsearch(level)+1]
		save()

		if level == "1-2":
			$Bartender_dialog/Label.text = "An arcade machine has been added. You can use it to train for upcoming battles"
		if level == "1-3":
			$Bartender_dialog/Label.text = "Following levels are going to get tougher. You can buy upgrades at the bar."

	if level == "1-1" and $arcade != null:
		$arcade.queue_free()
		$Bartender_dialog/Label.text = "Welcome to botsistance. Walk over to the portal and press TAB to enter a level. If you want to leave the game walk into the door on the right."

func get_blank_map():
	return {
		"player_name": "player",
		"stones": 0,
		"current_level": "1-1",
		"max_hp": 20,
		"speed": 340,
	}
	
func save():
	var dict = get_blank_map()
	dict["stones"] = get_tree().get_nodes_in_group("player")[0].stones
	dict["max_hp"] = get_tree().get_nodes_in_group("player")[0].max_hp
	dict["speed"] = get_tree().get_nodes_in_group("player")[0].SPEED
	dict["current_level"] = self.level
	
	var save_game = File.new()
	save_game.open("user://" + dict["player_name"] + ".save", File.WRITE)
	save_game.store_string(to_json(dict))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	save_game.open("user://player.save", File.READ)
	var data = parse_json(save_game.get_as_text())
	save_game.close()
	
	print(get_tree().get_nodes_in_group("player")[0])
	
	if data != null:
		self.level = data["current_level"]
		if get_parent() in get_tree().get_nodes_in_group("player"):
			get_parent().stones = data["stones"]
			get_parent().hp = data["max_hp"]
			get_parent().SPEED = data["speed"]
		else:
			get_tree().get_nodes_in_group("player")[0].stones = data["stones"]
			get_tree().get_nodes_in_group("player")[0].hp = data["max_hp"]
			get_tree().get_nodes_in_group("player")[0].SPEED = data["speed"]
