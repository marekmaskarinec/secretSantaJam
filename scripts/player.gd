extends KinematicBody2D

const SPEED = 340

var motion = Vector2()
var hitDict
var direction = 1
var hp = 60
var oa
var stones = 0

func take_damage(dm):
	if hp - dm > 0:# and OS.get_datetime()["second"] - lastHit > 1:
		hp -= dm
		$Camera2D/UI/UiTween.interpolate_property($Camera2D/UI/VBoxContainer/HPBar, "value", $Camera2D/UI/VBoxContainer/HPBar.value, hp, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Camera2D/UI/UiTween.start()
		$AnimationPlayer2.play("damage")
		#$Camera2D/UI/VBoxContainer/HPBar.value = hp
		#print(hp)
	else:
		print("died")

func _ready():
	hitDict = {
		"simple_bullet": print("hit by simple bullet")
	}
	get_node("AnimationPlayer").play("main")

func _process(delta):
	
	# MOVEMENT
	motion = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		motion += Vector2(0, 1*-SPEED)
		get_node("AnimatedSprite").animation = "up"
		direction = 1
	if Input.is_action_pressed("down"):
		motion += Vector2(0, 1*SPEED)
		get_node("AnimatedSprite").animation = "down"
		direction = 3
		
	if Input.is_action_pressed("right"):
		motion += Vector2(1*SPEED, 0)
		get_node("AnimatedSprite").animation = "right"
		direction = 2
		
	if Input.is_action_pressed("left"):
		motion += Vector2(1*-SPEED, 0)
		get_node("AnimatedSprite").animation = "left"
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
		
	# OBJECT INTERACTION
	oa = $hitbox.get_overlapping_areas()
	for i in range(len(oa)):
		if "portal" in oa[i].name:
			if Input.is_action_just_pressed("ui_focus_next"):
				$Tween.interpolate_property($Panel, "modulate", Color(0,0,0,0), Color(0,0,0,1), 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
				$Tween.start()
				#get_tree().change_scene("res://scenes/pub.tscn")
		if "chest" in oa[i].name:
			if Input.is_action_just_pressed("ui_focus_next"):
				self.stones += oa[i].get_parent().stones
				oa[i].get_parent().stones = 0

	if $Panel.get_modulate() == Color(0,0,0,1):
		OS.delay_msec(400)
		get_tree().change_scene("res://scenes/pub.tscn")
		
	$Camera2D/UI/VBoxContainer/stoneLabel.text = str(stones)
	
func hit(n):
	hitDict[n]
