extends KinematicBody2D

const PULL_SPEED = 20

var speed = 300
var path = PoolVector2Array()
var pull = false
var stretch = false
var selected = false
var connected = false
var bulletMap
var inst
var collision
var hp = 4
var lastPos
var offset#= Vector2(randi()%3, randi()%3)
var dm
var oa
var can_attack = true


func swarm_attack():
	var player = get_tree().get_nodes_in_group("player")[0]
	self.move_and_slide(global_position.direction_to(player.global_position)*5)
	can_attack = false
	player.take_dmg(dm)
	#self.take_damage(dm)
	stretch = true

func _ready():
	if "spawner" in name:
		hp = 12
		dm = 1
		offset = Vector2(0, 0)
		speed = 60
	elif "swarm" in name:
		hp = 1
		dm = 1
		offset = Vector2(randf()+1, randf()+1)
		speed = 300
		$CPUParticles2D.emitting = true
	get_node("Control/ProgressBar").max_value = hp
	#randomize()
	


func die():
	print("death")
	if self in get_tree().get_nodes_in_group("rope")[0].connections:
		get_tree().get_nodes_in_group("rope")[0].connections.remove(get_tree().get_nodes_in_group("rope")[0].connections.find_last(self))
	self.queue_free()

func take_damage(num):
	if self in get_tree().get_nodes_in_group("rope")[0].connections:
		print("disconnected")
		get_tree().get_nodes_in_group("rope")[0].connections.remove(get_tree().get_nodes_in_group("rope")[0].connections.find_last(self))
		move_and_slide(Vector2(0, 0))
		stretch = false
		pull = false
		connected = false
		get_tree().get_nodes_in_group("rope")[0].clear()
		#get_node("collider").disabled = true
	if num < hp:
		$AnimationPlayer.play("scenestakeDmg")
		hp -= num
		get_node("Control/ProgressBar").value = hp
		
	else:
		die()

func _process(delta):
	var ob = get_node("Area2D").get_overlapping_bodies()
	for i in range(len(ob)):
		if ob[i].name == "player":
			path = get_tree().get_nodes_in_group("pathfinder")[0].get_simple_path(self.global_position, ob[i].global_position+Vector2(randi()%20, randi()%20))
	
	var distance_to_walk = speed * delta
	
	if path.size() > 0:
		position -= offset

	
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = global_position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			global_position += global_position.direction_to(path[0]) * distance_to_walk
		else:
			global_position = path[0]
			path.remove(0)
		distance_to_walk -= distance_to_next_point
	if path.size() > 0:
	#	position -= offset
	#	offset = Vector2(randi()%20, randi()%20)
		position += offset

	if pull:
		if self.global_position != get_tree().get_nodes_in_group("rope")[0].global_position:
			get_node("collider").disabled = false
			collision = move_and_collide(self.global_position.direction_to(get_tree().get_nodes_in_group("rope")[0].global_position)*PULL_SPEED)
			if collision != null:
				take_damage(1)
				move_and_slide(global_position.direction_to(collision.collider.global_position))

		else:
			#get_node("collider").disabled = true
			move_and_slide(Vector2(0, 0))
			pull = false
	if stretch:
		if self.global_position.distance_to(get_tree().get_nodes_in_group("rope")[0].global_position) <= get_tree().get_nodes_in_group("rope")[0].lenght:
			get_node("collider").disabled = false
			collision = move_and_collide(self.global_position.direction_to(get_tree().get_nodes_in_group("rope")[0].global_position)*-PULL_SPEED)
			if collision != null:
				take_damage(1)
				move_and_slide(global_position.direction_to(collision.collider.global_position))
		else:
			#get_node("collider").disabled = true
			move_and_slide(Vector2(0, 0))
			stretch = false
			
	if connected:
		get_node("outline").visible = true
	else:
		get_node("outline").visible = false
		
	#if get_node("bullets").get_child_count() < 1 and path != null:
	#	inst = load(bulletMap[randi()%len(bulletMap)]).instance()
	#	inst.speed = self.global_position.direction_to(get_tree().get_nodes_in_group("player")[0].global_position)
	#	get_node("bullets").add_child(inst)
	lastPos = position

	if "spawner" in name:
		if get_parent().get_node("swarms").get_child_count() < int(hp/4):
			inst = load("res://scenes/enemy_swarm.tscn").instance()
			inst.global_position = global_position + Vector2(randf(), randf())/2
			get_parent().get_node("swarms").add_child(inst)

	if "swarm" in name:
		oa = $collisionArea.get_overlapping_areas()
		for i in range(len($collisionArea.get_overlapping_areas())):
			if "hitbox" in oa[i].name and can_attack:
				swarm_attack()
				#print("attack")
			else:
				can_attack = true

func _on_collisionArea_body_entered(body):
	if "enemy" in body.name:
		print("enemy")
		take_damage(dm)
		body.take_damage(dm)
	if "block" in body.name:
		print("block")
		if body.pull:
			take_damage(dm*2)
		if body.stretch:
			take_damage(dm*2)
	if "shield" in body.name:
		if true:#body.energy >= dm:
			body.energy -= dm
			print("shield")
			move_and_slide(-global_position.direction_to(body.global_position))
			take_damage(dm)


