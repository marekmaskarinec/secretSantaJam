extends KinematicBody2D

const SPEED = 120

var motion = Vector2()

func _ready():
	pass

func _process(delta):
	
	# MOVEMENT
	motion = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		motion += Vector2(0, 1*-SPEED)
	if Input.is_action_pressed("down"):
		motion += Vector2(0, 1*SPEED)
	if Input.is_action_pressed("right"):
		motion += Vector2(1*SPEED, 0)
	if Input.is_action_pressed("left"):
		motion += Vector2(1*-SPEED, 0)
	
	move_and_slide(motion)
	
	# ROPE
	
	if Input.is_action_just_pressed("pull"):
		get_node("rope").pull()
	if Input.is_action_just_pressed("stretch"):
		get_node("rope").stretch()
