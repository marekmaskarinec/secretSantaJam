extends Node2D


var connections = []
var max_connections = 3
var lenght = 600

func pull():
	var tween = get_node("tween")
	if len(connections) > 1:
		for i in range(len(connections)):
			if not connections[i].pull:
				connections[i].pull = true
			else:
				connections[i].pull = false
				connections[i].get_node("collider").disabled = true
			connections[i].stretch = false
			#tween.interpolate_property(connections[i], "global_position",
			#		connections[i].global_position, self.global_position, 0.2,
			#		Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
			#tween.start()

func stretch():
	var tween = get_node("tween")
	var incr
	var used_random = false
	if len(connections) > 1:
		for i in range(len(connections)):
			if not connections[i].stretch:
				connections[i].stretch = true
			else:
				connections[i].stretch = false
				connections[i].get_node("collider").disabled = true
				
			connections[i].pull = false


func add_connection(node):
	if len(connections) < max_connections:
		connections.append(node)
	else:
		connections[0].connected = false
		connections.remove(0)
		
		connections.append(node)

func _process(delta):
	if len(connections) >= 2:
		if connections[0].global_position.x > connections[1].global_position.x:
			self.global_position.x = connections[0].global_position.x - (connections[0].global_position.x - connections[1].global_position.x)/2
		else:
			self.global_position.x = connections[1].global_position.x - (connections[1].global_position.x - connections[0].global_position.x)/2
		if connections[0].global_position.y > connections[1].global_position.y:
			self.global_position.y = connections[0].global_position.y - (connections[0].global_position.y - connections[1].global_position.y)/2
		else:
			self.global_position.y = connections[1].global_position.y - (connections[1].global_position.y - connections[0].global_position.y)/2
	else:
		self.position = Vector2(-32, 25)

	if Input.is_action_just_pressed("cancel"):
		for i in range(len(connections)):
			connections[i].connected = false
		connections = []
