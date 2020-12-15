extends Node2D


var connections = []
var max_connections = 1
var lenght = 500000

func clear():
	for i in range(len(connections)):
		connections[i].connected = false
		#connections[i].pull = false
		#connections[i].stretch = false
		
	connections = []

func pull():
	if len(connections) > 0:
		for i in range(len(connections)):
			if connections[i] != null:
				if not connections[i].pull:
					connections[i].pull = true
				else:
					connections[i].pull = false
					connections[i].get_node("collider").disabled = true
				connections[i].stretch = false
			#connections[i].hold = false
			#tween.interpolate_property(connections[i], "global_position",
			#		connections[i].global_position, self.global_position, 0.2,
			#		Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
			#tween.start()
	#elif len(connections) > 0 and len(connections) < 2:
	#	connections[0].hold = true
func stretch():
	var used_random = false
	if len(connections) > 0:
		for i in range(len(connections)):
			if connections[i] != null:
				if not connections[i].stretch:
					connections[i].stretch = true
				else:
					connections[i].stretch = false
					connections[i].get_node("collider").disabled = true
					
				connections[i].pull = false
	#elif len(connections) > 0 and connections[0].hold:
		#connections[0].move_and_slide(connections[0].global_position.direction_to(get_global_mouse_position()))
		#connections[0].hold = false
		#connections[0].throw = true
		#clear()

func add_connection(node):
	if len(connections) >= max_connections:

		if connections[0] != null:
			connections[0].connected = false
		connections.remove(0)
		
	if not node in connections:
		connections.append(node)

func _process(_delta):
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
		self.position = Vector2(0,0)

	if Input.is_action_just_pressed("cancel"):
		for i in range(len(connections)):
			if connections[i] != null:
				connections[i].connected = false
		connections = []
