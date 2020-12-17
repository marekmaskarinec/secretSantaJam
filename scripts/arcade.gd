extends Node

func play():
	get_tree().get_root().add_child(load("res://arcade_maps/" + str(randi()%7) + ".tscn").instance())
