extends CharacterBody2D
class_name BaseEnemy

@export var max_health: float
@export var health: float
@export var gravity: float = 980
var target :Player
var chase: bool
var chase_timer: Timer
@export var sight: float
@export var speed: float

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	chase = false


func player_sight_line(pos: Vector2) -> Vector2:
	var delta = target.global_position - pos
	if delta.length_squared() > sight:
		return Vector2.INF
	return delta

func can_see_player(pos: Vector2) -> bool:
	if player_sight_line(pos) == Vector2.INF:
		return false
	return true

func take_damage(damage: float):
	health -= damage
	if health <= 0:
		death()

func death():
	pass
	
func ai_move(_delta: float):
	pass

func _handle_collide(_object):
	pass

func _physics_process(delta: float):
	velocity.y += delta * gravity
	ai_move(delta)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		_handle_collide(collision.get_collider())
	
