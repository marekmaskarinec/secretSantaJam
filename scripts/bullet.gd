extends KinematicBody2D

const PULL_SPEED = 5

var speed = Vector2(1, 0)
var n = "simple_bullet"
var collision
var pull = false
var stretch = false
var t = 0
	
func _process(delta):
	t += delta
	
	if t >= 2:
		print("timeout")
		queue_free()
	
	collision = move_and_collide(speed*0.002)
	if collision != null:
		if collision.collider in get_tree().get_nodes_in_group("attackable"):
			collision.collider.hit(n)
			if self in get_tree().get_nodes_in_group("rope")[0].connections:
				get_tree().get_nodes_in_group("rope")[0].connections.remove(get_tree().get_nodes_in_group("rope")[0].connections.find_last(self))
			self.queue_free()

	if pull:
		if self.global_position != get_tree().get_nodes_in_group("rope")[0].global_position:
			get_node("collider").disabled = false
			move_and_collide(self.global_position.direction_to(get_tree().get_nodes_in_group("rope")[0].global_position)*PULL_SPEED)
		else:
			get_node("collider").disabled = true
			move_and_slide(Vector2(0, 0))
			pull = false
	if stretch:
		if self.global_position.direction_to(get_tree().get_nodes_in_group("rope")[0].global_position) <= get_tree().get_nodes_in_group("rope")[0].lenght:
			get_node("collider").disabled = false
			move_and_collide(self.global_position.direction_to(get_tree().get_nodes_in_group("rope")[0].global_position)*-PULL_SPEED)
		else:
			get_node("collider").disabled = true
			move_and_slide(Vector2(0, 0))
			stretch = false
