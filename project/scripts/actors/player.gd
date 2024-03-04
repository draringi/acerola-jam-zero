extends CharacterBody2D

class_name Player

signal health_changed

@export var speed: float = 400
@export var gravity: float = 980
@export var jump_speed: float = -500
@export var health: float = 20
@export var max_health: float = 20
@export var energy: float = 50
@export var max_energy: float = 50
@export var energy_recovery_rate: float = 1.2
@export var shoot_period: float = 0.5
var shoot_cost: float = 2
var air_accel: float = 1000

var camera: Camera2D
var firerate: Timer
var projectile_scene: PackedScene = preload("res://scenes/actors/attacks/pistol_shot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $Camera2D
	firerate = $Firerate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if Input.is_action_pressed("shoot") and can_shoot():
		shoot()
	if energy < max_energy:
		energy += energy_recovery_rate * delta
		if energy > max_energy:
			energy = max_energy

func _physics_process(delta: float):
	velocity.y += delta * gravity
	
	var jump := Input.is_action_just_pressed("jump")
	
	if jump:
		if is_on_floor():
			velocity.y = jump_speed
		elif is_on_wall_only():
			velocity.x = get_wall_normal().x * speed
			velocity.y = jump_speed/2
	
	if is_on_floor():
		if Input.is_action_pressed("move_right"):
			# Move as long as the key/button is pressed.
			velocity.x = speed
		elif Input.is_action_pressed("move_left"):
			velocity.x = -speed
		else:
			velocity.x = 0
	else:
		if Input.is_action_pressed("move_right"):
			# Move as long as the key/button is pressed.
			velocity.x += air_accel * delta
			if velocity.x > speed:
				velocity.x = speed
		elif Input.is_action_pressed("move_left"):
			velocity.x -= air_accel * delta
			if velocity.x < -speed:
				velocity.x = -speed
		elif velocity.x > 0:
			var change = min(velocity.x, delta*air_accel/2)
			velocity.x -= change
		elif velocity.x < 0:
			var change = min(abs(velocity.x), delta*air_accel/2)
			velocity.x += change
	move_and_slide()

func set_camera_limits(left: int, right: int, top: int, bottom: int):
	camera.limit_left = left
	camera.limit_top = top
	camera.limit_right = right
	camera.limit_bottom = bottom

func can_shoot() -> bool:
	if energy < shoot_cost:
		return false
	return firerate.is_stopped()

func shoot():
	energy -= shoot_cost
	var pos = $ShootSrc.global_position
	var projectile := projectile_scene.instantiate()
	projectile.position = pos
	projectile.direction = pos.direction_to(get_global_mouse_position())
	var game = get_node("../GameCode")
	game.register_projectile(projectile)
	firerate.start(shoot_period)
