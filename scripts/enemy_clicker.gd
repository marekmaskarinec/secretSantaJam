extends Area2D

func _input_event(viewport, event, shape_idx):
	#print(event.get_class())
	if event.get_class() == "InputEventMouseButton" and event.button_index == BUTTON_LEFT and event.pressed:
		print("clicked")
		get_tree().get_nodes_in_group("rope")[0].add_connection(get_parent())
