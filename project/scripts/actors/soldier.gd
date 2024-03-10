extends BaseEnemy

var shoot_range : float = 300*300
@onready var firerate: Timer = $Firerate
var shoot_period: float = 0.6
var projectile_scene: PackedScene = preload("res://scenes/actors/attacks/solder_shot.tscn")
@onready var ShootSource = $ShootSrc
@onready var recheckPath: Timer = $PathTimer
var last_seen: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node("../Player")
	eyes = $eyes
	max_health = 5
	health = 5
	speed = 200
	air_accel = 100
	sight = 400*400
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 40.0
	chase = false
	configure_agent()

func _process(_delta):
	var aim_vector = player_sight_line()
	if aim_vector != Vector2.INF and aim_vector.length_squared() >= shoot_range/2:
		chase = true
		if recheckPath.is_stopped():
			navigation_agent.target_position = target.global_position
			recheckPath.start(1)
	elif aim_vector != Vector2.INF:
		chase = true
	else:
		chase = false
	if can_shoot(aim_vector):
		shoot(aim_vector)

func can_shoot(aim_vector: Vector2) -> bool:
	return firerate.is_stopped() and aim_vector.length_squared() <= shoot_range

func shoot(aim_vector: Vector2):
	var pos: Vector2 = ShootSource.global_position
	var projectile := projectile_scene.instantiate()
	projectile.position = pos
	projectile.direction = aim_vector.normalized()
	var game = get_node("../GameCode")
	game.register_projectile(projectile)
	firerate.start(shoot_period)

func should_jump() -> bool:
	if navigation_agent.is_navigation_finished():
		return false
	var next_waypoint = navigation_agent.get_next_path_position()
	var dir = global_position.direction_to(next_waypoint)
	if dir.dot(Vector2.UP) > 0:
		return true
	return false

func get_desired_direction():
	if navigation_agent.is_navigation_finished():
		return MoveDirection.STOP
	if chase:
		var next_waypoint = navigation_agent.get_next_path_position()
		var dir = global_position.direction_to(next_waypoint)
		print("Target is in direction", dir.x," and ", dir.y)
		if dir.x > 0:
			return MoveDirection.RIGHT
		if dir.x < 0:
			return MoveDirection.LEFT
	return MoveDirection.STOP

func death():
	queue_free()


