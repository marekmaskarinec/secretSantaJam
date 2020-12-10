extends KinematicBody2D

var collision = null
var motion
var speed = 10
#var oa

func _ready():
	motion = global_position.direction_to(get_tree().get_nodes_in_group("player")[0].global_position)*speed
	
func handle_col(col):
	if col != null:
		#print(col.name)
		if not "shooter" in col.name and "enemy" in col.name or "player" in col.name:
			#print("hit")
			col.take_damage(2)
		self.queue_free()
	
func _process(_delta):


	
	if collision == null:
		collision = move_and_collide(motion)
	else:
		handle_col(collision.collider)
