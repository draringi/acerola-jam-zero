extends Area2D


var direction := Vector2.ZERO
@export var speed: float = 1000
var damage: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta):
	var velocity = speed * direction
	var motion = velocity * delta
	position += motion

func _handle_collide(object):
	if "player_damage" in object:
		object.player_damage(damage)
	queue_free()
