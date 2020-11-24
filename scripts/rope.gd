extends Node2D


var connections = []
var max_connections = 3
var lenght = 600

func pull():
	var tween = get_node("tween")
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
	for i in range(len(connections)):
		"""if connections[i].global_position.x > 0:
			incr = Vector2((connections[i].global_position.x - self.global_position.x)/connections[i].global_position.x, (connections[i].global_position.y - self.global_position.y)/connections[i].global_position.y)
		else:
			incr = -Vector2((connections[i].global_position.x - self.global_position.x)/connections[i].global_position.x, (connections[i].global_position.y - self.global_position.y)/connections[i].global_position.y)
		
		if incr == Vector2(0, 0) and not used_random:
			incr = Vector2(randf(), randf())
			
		tween.interpolate_property(connections[i], "global_position",
				connections[i].global_position, connections[i].global_position + (incr * lenght), 0.2,
				Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		tween.start()"""
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
