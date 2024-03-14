extends BaseEnemy

var melee_damage: float = 1
@onready var sleep_timer: Timer= $SleepTimer
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node("../Player")
	eyes = $eyes
	max_health = 2
	health = 2
	speed = 100
	air_accel = 100
	set_sight(1000)
	chase = false
	configure_agent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if sleep_timer.is_stopped() and can_see_player:
		chase = true
	else:
		chase = false

func jump_fx():
	jump_sound.play()

func death():
	queue_free()

func should_jump() -> bool:
	return chase

func get_desired_direction():
	if chase:
		var dir = global_position.direction_to(target.global_position)
		if dir.x > 0:
			return MoveDirection.RIGHT
		if dir.x < 0:
			return MoveDirection.LEFT
	return MoveDirection.STOP

func _handle_collide(object):
	if sleep_timer.is_stopped() and "player_damage" in object:
		object.player_damage(melee_damage)
		sleep_timer.start(0.5)
