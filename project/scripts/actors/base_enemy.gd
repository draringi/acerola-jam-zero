extends CharacterBody2D
class_name BaseEnemy

@export var max_health: float
var health: float
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var air_accel: float = 1000
var jump_speed: float = -500
var target :Player
var chase: bool
var chase_timer: Timer
var eyes: Node2D
@export var sight: float
@export var speed: float
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
enum MoveDirection {LEFT, RIGHT, STOP}
var can_see_player: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func can_see(item: Player) -> bool:
	if eyes == null:
		return false
	var space_state = get_world_2d().direct_space_state
	var positions = [item.global_position, item.shoot_src.global_position]
	for loc in positions:
		var target_direction: Vector2 = (loc - eyes.global_position).normalized() * sight
		var query = PhysicsRayQueryParameters2D.create(eyes.global_position, target_direction, collision_mask, [self])
		var result := space_state.intersect_ray(query)
		if result != null and result.has("collider"):
			if result.collider == item:
				return true
	return false

func player_sight_line() -> Vector2:
	var delta = target.global_position - eyes.global_position
	if can_see_player:
		return delta
	return Vector2.INF

func take_damage(damage: float):
	health -= damage
	if health <= 0:
		death()

func death():
	pass
	
func ai_move(delta: float, direction: MoveDirection, jump: bool):
	velocity.y += delta * gravity
	
	if jump:
		if is_on_floor():
			velocity.y = jump_speed
		elif is_on_wall_only():
			velocity.x = get_wall_normal().x * speed
			velocity.y = jump_speed/2
	
	if is_on_floor():
		if direction == MoveDirection.RIGHT:
			# Move as long as the key/button is pressed.
			velocity.x = speed
		elif direction == MoveDirection.LEFT:
			velocity.x = -speed
		else:
			velocity.x = 0
	else:
		if direction == MoveDirection.RIGHT:
			# Move as long as the key/button is pressed.
			velocity.x += air_accel * delta
			if velocity.x > speed:
				velocity.x = speed
		elif direction == MoveDirection.LEFT:
			velocity.x -= air_accel * delta
			if velocity.x < -speed:
				velocity.x = -speed
		elif velocity.x > 0:
			var change = min(velocity.x, delta*air_accel/2)
			velocity.x -= change
		elif velocity.x < 0:
			var change = min(abs(velocity.x), delta*air_accel/2)
			velocity.x += change
	return velocity

func _handle_collide(_object):
	pass

func should_jump() -> bool:
	return false

func get_desired_direction() -> MoveDirection:
	return MoveDirection.STOP

func _physics_process(delta: float):
	var direction := get_desired_direction()
	ai_move(delta, direction, should_jump())
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		_handle_collide(collision.get_collider())
	if target != null:
		can_see_player = can_see(target)
	
func configure_agent():
	navigation_agent.max_speed = speed
	
