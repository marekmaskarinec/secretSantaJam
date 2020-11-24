extends KinematicBody2D

const SPEED = 340

var motion = Vector2()
var hitDict
var direction = 1

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
		direction = 1
	if Input.is_action_pressed("down"):
		motion += Vector2(0, 1*SPEED)
		get_node("AnimatedSprite").animation = "walk_down"
		direction = 3
		
	if Input.is_action_pressed("right"):
		motion += Vector2(1*SPEED, 0)
		get_node("AnimatedSprite").animation = "walk_right"
		direction = 2
		
	if Input.is_action_pressed("left"):
		motion += Vector2(1*-SPEED, 0)
		get_node("AnimatedSprite").animation = "walk_left"
		direction = 4
		
	
	if motion == Vector2(0, 0):
		get_node("AnimatedSprite").animation = "default"
		direction = 3
	
	move_and_slide(motion)
	
	# ROPE
	
	if Input.is_action_just_pressed("pull"):
		get_node("rope").pull()
	if Input.is_action_just_pressed("stretch"):
		get_node("rope").stretch()

func hit(n):
	hitDict[n]
