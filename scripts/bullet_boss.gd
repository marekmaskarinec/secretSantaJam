extends KinematicBody2D

var collision = null
var motion
var speed = 10
var added_time
var oa

func _ready():
	var num_map = {
		0: -1,
		1: 1
	}
	motion = Vector2((randf()*4+0.2)*num_map[randi()%2], (randf()*4+0.2)*num_map[randi()%2])
	added_time = OS.get_datetime()["second"]
	
func handle_col(col):
	if col != null:
		if "enemy" in col.name or "player" in col.name and not "shooter" in col.name:
			#print("hit")
			col.take_damage(2)
		if not "boss" in col.name and not "bullet" in col.name:
			#print("died of " + str(col.name))
			self.queue_free()
	
func _process(_delta):
	oa = $Area2D.get_overlapping_bodies()
	#print(len(oa))
	
	for i in range(len(oa)):
		if "player" in oa[i].name or "tilemap" in oa[i].name:
			oa[i].take_damage(2)
			#self.queue_free()
	if OS.get_datetime()["second"] - added_time >= 3 or OS.get_datetime()["second"] - added_time < 0:
		#print("died of time")
		queue_free()
	if collision == null:
		collision = move_and_collide(motion)
	else:
		handle_col(collision.collider)
