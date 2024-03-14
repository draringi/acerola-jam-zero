extends Area2D

@export var heal_amount: float = 5


func _handle_collide(object):
	if "heal_damage" in object:
		object.heal_damage(heal_amount)
		queue_free()
