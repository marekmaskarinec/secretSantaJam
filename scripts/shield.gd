extends StaticBody2D

const MAX_ENERGY = 100

var energy = 100

func _process(delta):
	get_node("icon").modulate.a = 0.01 * energy
