extends Panel


func _process(delta):
	#print(modulate)
	if modulate == Color(1,1,1,1):
		$Label.visible = true
		OS.delay_msec(400)
		get_tree().quit()
