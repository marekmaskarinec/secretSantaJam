extends KinematicBody2D

const PULL_SPEED = 5

var speed = 80
var path = PoolVector2Array()
var pull = false
var stretch = false
var selected = false

func _process(delta):
	var ob = get_node("Area2D").get_overlapping_bodies()
	for i in range(len(ob)):
		if ob[i].name == "player":
			path = get_tree().get_nodes_in_group("pathfinder")[0].get_simple_path(self.global_position, ob[i].global_position)
	
	var distance_to_walk = speed * delta
	
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			position = path[0]
			path.remove(0)
		distance_to_walk -= distance_to_next_point

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
