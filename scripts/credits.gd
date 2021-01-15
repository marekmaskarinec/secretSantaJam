extends Control

var t = 0

func _ready():
	$Tween.interpolate_property($VBoxContainer, "rect_position", Vector2(0,1600), Vector2(0, -2000), 42, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func _process(delta):
	if $VBoxContainer.rect_position.y == -2000 and visible:
		get_tree().get_root().add_child(load("res://scenes/pub.tscn").instance())
		get_tree().get_nodes_in_group("music")[0].queue_free()
		self.visible = false
		
