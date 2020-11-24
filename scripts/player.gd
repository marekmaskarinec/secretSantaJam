extends KinematicBody2D

const SPEED = 280

var motion = Vector2()
var hitDict

func _ready():
	hitDict = {
		"simple_bullet": print("hit by simple bullet")
	}

func _process(delta):
	
	# MOVEMENT
	motion = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		motion += Vector2(0, 1*-SPEED)
		get_node("AnimatedSprite").animation = "walk_up"
	if Input.is_action_pressed("down"):
		motion += Vector2(0, 1*SPEED)
		get_node("AnimatedSprite").animation = "walk_down"
	if Input.is_action_pressed("right"):
		motion += Vector2(1*SPEED, 0)
		get_node("AnimatedSprite").animation = "walk_right"
	if Input.is_action_pressed("left"):
		motion += Vector2(1*-SPEED, 0)
		get_node("AnimatedSprite").animation = "walk_left"
	
	if motion == Vector2(0, 0):
		get_node("AnimatedSprite").animation = "default"
	
	move_and_slide(motion)
	
	# ROPE
	
	if Input.is_action_just_pressed("pull"):
		get_node("rope").pull()
	if Input.is_action_just_pressed("stretch"):
		get_node("rope").stretch()

func hit(n):
	hitDict[n]
