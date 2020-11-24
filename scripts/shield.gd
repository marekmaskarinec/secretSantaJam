extends StaticBody2D

const MAX_ENERGY = 10

var energy = 10

func _process(delta):
	print(energy)
	get_node("icon").set_modulate(Color(0, 0, 0, 1/MAX_ENERGY*energy))
