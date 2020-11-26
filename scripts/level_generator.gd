extends Node2D

var spawn_nodes
var max_spawners
var max_shooters
var max_tanks
var max_swarms
var spawners = 0
var shooters = 0
var tanks = 0
var swarms = 0
var inst
var enemy_map
var random
var num_map
var num_map_2

func get_num_map():
	return {
		0: spawners < max_spawners,
		1: swarms < max_swarms,
		2: tanks < max_tanks,
		3: shooters < max_shooters,
	}

func _ready():
	randomize()
	spawn_nodes = get_children()
	max_spawners = int(len(spawn_nodes)*0.2)
	max_tanks = int(1)
	max_shooters = int(len(spawn_nodes)*0.6)
	max_swarms = int(len(spawn_nodes)*0.8)
	
	enemy_map = {
		0: load("res://scenes/enemy_spawner.tscn"),
		1: load("res://scenes/enemy_swarm.tscn"),
		2: load("res://scenes/enemy_tank.tscn"),
		3: load("res://scenes/enemy_shooter.tscn"),
	}
	
	num_map_2 = {
		0: spawners,
		1: swarms,
		2: tanks,
		3: shooters
	}

	print(max_shooters)
	print(max_spawners)
	print(max_swarms)

	for i in range(len(spawn_nodes)):
		random = randi()%4
		if get_num_map()[random]:
			inst = enemy_map[random].instance()
			inst.position = spawn_nodes[i].position
			add_child(inst)
			spawn_nodes[i].queue_free()
			num_map_2[random] += 1
		else:
			if i > 0:
				i -= 1
			else:
				i = 0

	for i in range(get_child_count()):
		print(get_children()[i].position)

func _process(delta):
	if get_child_count() <= 1:
		print("opening door")
		$door/Tween.interpolate_property($door, "rotation_degrees", $door.rotation_degrees, $door.rotation_degrees+90, 1, Tween.TRANS_BOUNCE, Tween.EASE_IN)
		$door/Tween.start()
		
	
