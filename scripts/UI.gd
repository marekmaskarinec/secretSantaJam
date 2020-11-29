extends Control

func _process(delta):
	self.rect_position = get_node("../player").position + Vector2(-320, -140)
