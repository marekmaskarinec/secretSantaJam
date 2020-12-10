extends Node2D

var spawn_nodes
var max_spawners
var max_shooters
var max_tanks
var max_swarms
var max_basics
var spawners = 0
var shooters = 0
var tanks = 0
var swarms = 0
var basics = 0
var inst
var enemy_map
var random
var num_map
var num_map_2
var max_map
var num_of_nodes
var door_open = false
var score = 0

func _ready():
	var save_game = File.new()
	save_game.open("user://player.save", File.READ)
	var data = parse_json(save_game.get_as_text())
	save_game.close()
	
	if data != null:
		get_tree().get_nodes_in_group("player")[0].stones = data["stones"]
		get_tree().get_nodes_in_group("player")[0].hp = data["max_hp"]
		get_tree().get_nodes_in_group("player")[0].SPEED = data["speed"]

	
	
	randomize()
	spawn_nodes = get_children()
	num_of_nodes = len(spawn_nodes)-1
	max_spawners = int(1)
	max_tanks = int(0)
	max_shooters = int(len(spawn_nodes)*0.4)
	max_basics = int(len(spawn_nodes)*0.6)
	max_swarms = int(len(spawn_nodes)*0.8)
	
	enemy_map = {
		0: load("res://scenes/enemy_spawner.tscn"),
		1: load("res://scenes/enemy_swarm.tscn"),
		2: load("res://scenes/enemy_tank.tscn"),
		3: load("res://scenes/enemy_shooter.tscn"),
		4: load("res://scenes/enemy_basic.tscn")
	}
	
	num_map = {
		0: spawners,
		1: swarms,
		2: tanks,
		3: shooters,
		4: basics
	}

	max_map = {
		0: max_spawners,
		1: max_swarms,
		2: max_tanks,
		3: max_shooters,
		4: max_basics
	}

	var enemies = 0

	for i in range(len(spawn_nodes)-1):
		random = randi()%5
		if num_map[random] < max_map[random]:
			inst = enemy_map[random].instance()
			inst.position = spawn_nodes[i].position
			add_child(inst)
			#spawn_nodes[i].queue_free()
			num_map[random] += 1
			enemies += 1
		else:
			if i > 0:
				i -= 1
			else:
				i = 0

	#print(enemies)
	
func _process(_delta):
	var spawners = 0
	for i in range(get_child_count()):
		if "spawner" in get_children()[i].name:
			spawners += 1
	
	#if true:#get_child_count() <= 3:
	#print(get_child_count()-num_of_nodes)
	#print(int((score+40)/100))
	if get_child_count()-num_of_nodes <= int((score+40)/80):
		random = randi()%5
		if random != 2 and spawners < 2:
			inst = enemy_map[random].instance()
			inst.position = spawn_nodes[randi()%num_of_nodes].position
			add_child(inst)
			#spawn_nodes[i].queue_free()
			num_map[random] += 1

	$scoreLabel.text = str(score)
