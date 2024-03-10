extends BaseEnemy

func _ready():
	target = get_node("../Player")
	max_health = 12
	health = 12
	speed = 300
	sight = 600*600
	chase = false
