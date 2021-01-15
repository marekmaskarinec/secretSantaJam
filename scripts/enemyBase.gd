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
	stretch = true

func _ready():
	
	# setting up level>5 textures
	if get_tree().get_root().get_node("level/2") != null or get_tree().get_root().get_node("arcade/2") != null:
		var sprite_map = {
			"enemy_spawner": "res://sprites/spawner2.png",
			"enemy_basic": "res://sprites/basic2.png",
			"enemy_swarm": "res://sprites/spawner2.png",
			"shooter": "res://sprites/shooter2.png",
		}
		if "shooter" in name:
			$icon.texture = load("res://sprites/shooter2.png")
			$outline.texture = load("res://sprites/outline2-2.png")
			$icon.scale = Vector2(0.8, 0.8)
			$outline.scale = Vector2(0.84, 0.84)
		if "swarm" in name:
			$icon.texture = load("res://sprites/spawner2.png")
			$outline.texture = load("res://sprites/outline2-1.png")
			$icon.scale *= 1.5
			$outline.scale *= 1.5
			if get_parent().name != "swarms":
				$AudioStreamPlayer2D2.playing = true
		if "spawner" in name:
			$outline.texture = load("res://sprites/outline2-1.png")
			$icon.texture = load("res://sprites/spawner2.png")
			$icon.scale *= 1.5
			$outline.scale *= 1.5
		if "basic" in name:
			$icon.texture = load("res://sprites/basic2.png")
			$outline.texture = load("res://sprites/outline2-2.png")
			$icon.scale *= 1.5
			$outline.scale *= 1.5
	
	if "spawner" in name:
		hp = 10
		dm = 1
		offset = Vector2(0, 0)
		speed = 60
		toGive = 2
	if "tank" in name:
		hp = 20
		dm = 0
		offset = Vector2(0, 0)
		speed = 160
		toGive = 1
	if "basic" in name:
		hp = 4
		dm = 0
		offset = Vector2(randf()/2, randf()/2)
		speed = 200
		toGive = 1
	elif "swarm" in name:
		hp = 1
		dm = 1
		offset = Vector2(randf()+0.5, randf()+0.5)
		speed = 300
		$CPUParticles2D.emitting = true
		toGive = 0
	elif "shooter" in name:
		hp = 2
		dm = 1
		offset = Vector2(0, 0)
		speed = 20
		lastShot = OS.get_datetime()["second"]
		toGive = 0
	get_node("Control/ProgressBar").max_value = hp
	explosion = load("res://scenes/explosion.tscn")

func explosion_played():
	$explosion_sound.queue_free()
	if not "swarm" in name and not "basic" in name:
		get_parent().queue_free()
	else:
		queue_free()
	

func die():
	inst = explosion.instance()
	inst.connect("finished", self, "explosion_played")
	add_child(inst)
	$explosion_sound.autoplay = false
	if self in get_tree().get_nodes_in_group("rope")[0].connections:
		get_tree().get_nodes_in_group("rope")[0].connections.remove(get_tree().get_nodes_in_group("rope")[0].connections.find_last(self))
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
	
	lastPos = position

	if "spawner" in name:
		if get_parent().get_node("swarms").get_child_count() < int(hp/4):
			inst = load("res://scenes/enemy_swarm.tscn").instance()
			inst.position = position + Vector2(randf(), randf())/2
			get_parent().get_node("swarms").add_child(inst)

	if "swarm" in name or "basic" in name:
		oa = $collisionArea.get_overlapping_areas()
		for i in range(len($collisionArea.get_overlapping_areas())):
			if "hitbox" in oa[i].name and can_attack:
				swarm_attack()
			else:
				can_attack = true
				
	if "shooter" in name and path != null:
		if path.size() > 0:
			if get_parent().get_node("bullets").get_child_count() < 1:
				if OS.get_datetime()["second"] - lastShot >= 2 or OS.get_datetime()["second"] - lastShot:
					lastShot = OS.get_datetime()["second"]
					inst = load("res://scenes/bullet.tscn").instance()
					playerPos = global_position.direction_to(get_tree().get_nodes_in_group("player")[0].global_position)
					if playerPos.x < playerPos.y:
						inst.position = position
					else:
						inst.position = position
					get_parent().get_node("bullets").add_child(inst)

func _on_collisionArea_body_entered(body):
	if "enemy" in body.name:
		take_damage(dm)
		body.take_damage(dm)
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
		if true:
			body.energy -= dm
			move_and_slide(-global_position.direction_to(body.global_position))
			take_damage(dm)

func _on_Button_pressed():
	if path.size() > 0:
		$outline.visible = true
		self.connected = true
		get_tree().get_nodes_in_group("rope")[0].add_connection(self)
	
func _on_Button_mouse_entered():
	if path.size() > 0:
		$outline.visible = true
		self.connected = true
		get_tree().get_nodes_in_group("rope")[0].add_connection(self)

func _on_Button_mouse_exited():
	if not stretch and not pull:
		$outline.visible = false
		self.connected = false
		get_tree().get_nodes_in_group("rope")[0].clear()
