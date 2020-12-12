extends Node2D

func _ready():
	randomize()
	var tex = "res://sprites/bots/" + str(randi()%4) + ".png"
	print(tex)
	$StaticBody2D/bartender.texture = load(tex)
	var rng = randi()%1000
	if rng < 400:
		self.queue_free()
	randomize()
	self.position += Vector2(randi()%30-15, randi()%30-15)

	$AnimationPlayer.play("New Anim")
