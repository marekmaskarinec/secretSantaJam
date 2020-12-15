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
var dead = false
var lastShot
var playerPos
var toGive
var explosion

func swarm_attack():
	var player = get_tree().get_nodes_in_group("player")[0]
	self.move_and_slide(global_position.direction_to(player.global_position)*5)
	can_attack = false
	player.take_damage(dm)
	#self.take_damage(dm)
	stretch = true

func _ready():
	hp = 30
	dm = 1
	offset = Vector2(0, 0)
	speed = 60
	toGive = 30

	get_node("Control/ProgressBar").max_value = hp
	#randomize()
	explosion = load("res://scenes/explosion.tscn")

func explosion_played():
	#print("sound finnished")
	$explosion_sound.queue_free()
	OS.delay_msec(400)
	get_tree().change_scene_to(load("res://scenes/credits.tscn"))

func die():
	inst = explosion.instance()
	inst.connect("finished", self, "explosion_played")
	add_child(inst)
	$explosion_sound.autoplay = false
	if self in get_tree().get_nodes_in_group("rope")[0].connections:
		get_tree().get_nodes_in_group("rope")[0].connections.remove(get_tree().get_nodes_in_group("rope")[0].connections.find_last(self))
	#self.queue_free()
	$outline.visible = false
	$icon.visible = false
	$explosion.emitting = true
	$Control.visible = false
	dead = true
	if get_tree().get_root().get_node("arcade") != null and get_parent().name != "swarms":
		get_tree().get_root().get_node("arcade/room1").score += toGive+1*10
	else:
		get_tree().get_nodes_in_group("player")[0].stones += toGive
	
func take_damage(num):
	if self in get_tree().get_nodes_in_group("rope")[0].connections:
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
		if not dead:
			die()

func _process(delta):
	if dead:
		self.connected = false
	
	#if dead and not $explosion.emitting:
	#	if not "swarm" in name and not "basic" in name:
	#		get_parent().queue_free()
	#	else:
	#		queue_free()
	
	var ob = get_node("Area2D").get_overlapping_bodies()
	for i in range(len(ob)):
		if ob[i].name == "player":
			path = get_tree().get_nodes_in_group("pathfinder")[0].get_simple_path(self.global_position, ob[i].global_position+Vector2(randi()%20, randi()%20))
	
	var distance_to_walk = speed * delta
	
	
	if path.size() > 0:

		position -= offset

	
	while distance_to_walk > 0 and path.size() > 0 and not dead:
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
			get_node("collider").disabled = true
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
			get_node("collider").disabled = true
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


	if get_parent().get_node("swarms").get_child_count() < int(hp/18)+1:
		inst = load("res://scenes/enemy_boss2_child.tscn").instance()
		inst.position = position + Vector2(randf(), randf())/2
		get_parent().get_node("swarms").add_child(inst)
				

func _on_collisionArea_body_entered(body):
	if "block" in body.name:
		if body.pull:
			take_damage(dm*2)
			body.stretch = false
			body.pull = true
		if body.stretch:
			take_damage(dm*2)
			body.stretch = true
			body.pull = false
	if "shield" in body.name:
		if true:#body.energy >= dm:
			body.energy -= dm
			move_and_slide(-global_position.direction_to(body.global_position))
			take_damage(dm)




func _on_Button_pressed():
	if path.size() > 0:
		$outline.visible = true
		self.connected = true
		get_tree().get_nodes_in_group("rope")[0].add_connection(self)
	
