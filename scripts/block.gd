extends KinematicBody2D

const PULL_SPEED = 20

var pull = false
var stretch = true
var connected = false

func _process(delta):
	if pull:
		if self.global_position != get_tree().get_nodes_in_group("rope")[0].global_position:
			get_node("collider").disabled = false
			move_and_collide(self.global_position.direction_to(get_tree().get_nodes_in_group("rope")[0].global_position)*PULL_SPEED)

		else:
			get_node("collider").disabled = true
			move_and_slide(Vector2(0, 0))
			pull = false
	if stretch:
		if self.global_position.distance_to(get_tree().get_nodes_in_group("rope")[0].global_position) <= get_tree().get_nodes_in_group("rope")[0].lenght:
			get_node("collider").disabled = false
			move_and_collide(self.global_position.direction_to(get_tree().get_nodes_in_group("rope")[0].global_position)*-PULL_SPEED)
		else:
			get_node("collider").disabled = true
			move_and_slide(Vector2(0, 0))
			stretch = false
			
	#if connected:
	#	get_node("outline").visible = true
	#else:
	#	get_node("outline").visible = false
