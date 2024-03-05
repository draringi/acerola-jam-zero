extends BaseEnemy

var air_accel: float = 100
var melee_damage: float = 1
@onready var sleep_timer: Timer= $SleepTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node("../Player")
	max_health = 2
	health = 2
	speed = 100
	sight = 400*400
	chase = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if sleep_timer.is_stopped() and can_see_player(global_position):
		chase = true
	else:
		chase = false

func death():
	queue_free()

func ai_move(delta: float):
	if chase and is_on_floor():
		var dir = global_position.direction_to(target.global_position)
		velocity.x = dir.x * speed
	else:
		if velocity.x > 0:
			var change = min(velocity.x, delta*air_accel/2)
			velocity.x -= change
		elif velocity.x < 0:
			var change = min(abs(velocity.x), delta*air_accel/2)
			velocity.x += change

func _handle_collide(object):
	if sleep_timer.is_stopped() and "player_damage" in object:
		object.player_damage(melee_damage)
		sleep_timer.start(0.5)
