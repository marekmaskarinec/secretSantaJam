extends Control

var active = false

func _process(_delta):
	self.rect_position = -get_viewport_rect().size/8
	if Input.is_action_just_pressed("ui_cancel"):
		if not active:
			active = true
			self.visible = true
			get_tree().paused = true
		else:
			active = false
			self.visible = false
			get_tree().paused = false


func _on_quitButton_pressed():
	get_tree().quit()


func _on_settingsButton_pressed():
	if $settingsUI.visible:
		$settingsUI.visible = false
	else:
		$settingsUI.visible = true
