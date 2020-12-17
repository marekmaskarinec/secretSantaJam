extends KinematicBody2D

var SPEED = 340

var motion = Vector2()
var hitDict
var direction = 1
var hp = 60
var oa
var stones = 0
var inst
var UI
var max_hp = 20
var shop
var in_shop = false
var arcade = false

func take_damage(dm):
	if hp - dm > 0:# and OS.get_datetime()["second"] - lastHit > 1:
		hp -= dm
		#UI.get_node("UiTween").interpolate_property(UI.get_node("VBoxContainer/HPBar"), "value", $Camera2D/UI/VBoxContainer/HPBar.value, hp, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		#UI.get_node("UiTween").start()
		UI.get_node("VBoxContainer/HPBar").value = hp
		if dm > 0:
			$AnimationPlayer2.play("damage")
		elif dm < 0:
			$heal_particles.emitting = true
		#$Camera2D/UI/VBoxContainer/HPBar.value = hp
		#print(hp)
	else:
		#print("died")
		if get_tree().get_root().get_node("level") != null:
			inst = load("res://scenes/death_screen.tscn").instance()
			#inst.rect_global_position = self.global_position
			add_child(inst)
		else:
			inst = load("res://scenes/game_over.tscn").instance()
			inst.score = get_node("../room1").score
			get_tree().get_root().add_child(inst)
			get_tree().get_root().get_node("arcade").queue_free()

func _ready():
	$save_manager.load_game()
	get_node("AnimationPlayer").play("main")
	UI = get_node("../UI")
	if UI != null:
		UI.get_node("VBoxContainer/HPBar").max_value = max_hp
	
	
	shop = load("res://scenes/shop.tscn")
	hp = max_hp
	
	
func _process(_delta):
	
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
				#add_child(load("res://scenes/scene_trans.tscn").instance())
				if get_parent().name == "pub" and get_node("../arcade") != null:
					get_node("../arcade").visible = false
					#get_node("../bot5").visible = false
				get_node("../portal_panel").visible = true
				$Tween.interpolate_property(get_node("../portal_panel"), "modulate", Color(0,0,0,0), Color(0,0,0,1), 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
				$Tween.start()
				#get_tree().change_scene("res://scenes/pub.tscn")
				if get_node("../portal_hider") != null:
					get_node("../portal_hider").visible = false
		if "chest" in oa[i].name:
			if Input.is_action_just_pressed("ui_focus_next"):
				self.stones += oa[i].get_parent().stones
				oa[i].get_parent().stones = 0
				UI.get_node("VBoxContainer/stoneLabel").text = str(stones)
		if "medkit" in oa[i].name:
			if Input.is_action_just_pressed("ui_focus_next"):
				take_damage(-int(oa[i].get_parent().name))				
				oa[i].name = "0"
		if "shop" in oa[i].name and not in_shop:
			if Input.is_action_just_pressed("ui_focus_next"):
				in_shop = true
				add_child(shop.instance())
		if "arcade" in oa[i].name:
				if Input.is_action_just_pressed("ui_focus_next"):
					#add_child(load("res://scenes/scene_trans.tscn").instance())
					get_node("../portal").visible = false
					get_node("../portal_panel").visible = true
					$Tween.interpolate_property(get_node("../portal_panel"), "modulate", Color(0,0,0,0), Color(0,0,0,1), 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
					$Tween.start()
					#get_tree().change_scene("res://scenes/pub.tscn")
					if get_node("../portal_hider") != null:
						get_node("../portal_hider").visible = false
					arcade = true
		if "exit" in oa[i].name:
				if not get_node("../exit_panel").visible:
					get_node("../exit_panel").visible = true
					$Tween.interpolate_property(get_node("../exit_panel"), "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
					$Tween.start()
					SPEED = 0
				#queue_free()

	if get_node("../portal_panel").get_modulate() == Color(0,0,0,1):
		OS.delay_msec(400)
		inst = load("res://scenes/pub.tscn").instance()
		inst.start = false
		if arcade:
			Arcade.play()
			get_parent().queue_free()
		else:
			if get_tree().get_root().get_node("level") != null:
				#inst.save()
				$save_manager.save()
				inst.level = get_tree().get_root().get_node("level/Control/Label").text
				get_tree().get_root().add_child(inst)
				get_tree().get_root().get_node("level").queue_free()
			else:
				get_tree().change_scene("res://levels/" + get_tree().get_root().get_node("pub").level + ".tscn")
				get_tree().get_root().get_node("pub").queue_free()
				
	if UI != null:
		UI.get_node("VBoxContainer/stoneLabel").text = str(stones)

