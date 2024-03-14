extends Area2D

func _handle_collide(object):
	if "death" in object:
		object.death()

