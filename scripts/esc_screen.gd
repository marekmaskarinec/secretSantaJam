extends Control

var active = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if not active:
			active = true
			self.visible = true
			get_tree().paused = true
		else:
			active = false
			self.visible = false
			get_tree().paused = false
