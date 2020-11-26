extends KinematicBody2D

const PULL_SPEED = 30

var pull = false
var stretch = false
var connected = false
var collision
var hold = false
var throw = false

func handle_col(c):
	if c.collider in get_tree().get_nodes_in_group("attackable"):
		c.collider.take_damage(c.collider.dm*2)
		c.collider.move_and_slide(Vector2(10, 10))
		move_and_slide(-global_position.direction_to(collision.collider.global_position)*randf())
		get_tree().get_nodes_in_group("rope")[0].clear()
		#print("cube")
		return true
		
func _process(delta):
	if pull:
		if self.global_position != get_tree().get_nodes_in_group("rope")[0].global_position or collision != null:
			get_node("collider").disabled = false
			collision = move_and_collide(self.global_position.direction_to(get_tree().get_nodes_in_group("rope")[0].global_position)*PULL_SPEED)
			if collision != null:
				#handle_col(collision)
				#stretch = true
				pull = false
				get_tree().get_nodes_in_group("rope")[0].clear()
				
		else:
			get_node("collider").disabled = true
			move_and_collide(Vector2(0, 0))
			pull = false
	if stretch:
		if self.global_position.distance_to(get_tree().get_nodes_in_group("rope")[0].global_position) <= get_tree().get_nodes_in_group("rope")[0].lenght or collision != null:
			get_node("collider").disabled = false
			collision = move_and_collide(self.global_position.direction_to(get_tree().get_nodes_in_group("rope")[0].global_position)*-PULL_SPEED)
			if collision != null:
				#handle_col(collision)
				stretch = false
				#pull = true
				get_tree().get_nodes_in_group("rope")[0].clear()
		else:
			get_node("collider").disabled = true
			move_and_collide(Vector2(0, 0))
			stretch = false
			
	if connected:
		get_node("outline").visible = true
	else:
		get_node("outline").visible = false
