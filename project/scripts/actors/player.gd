extends CharacterBody2D

class_name Player

signal health_changed
signal player_died

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
@onready var shoot_src: Marker2D = $ShootSrc
@onready var head: Marker2D = $head
@onready var feet: Marker2D = $feet
@onready var shoot_sound: AudioStreamPlayer2D = $ShotSound
@onready var grunt_1: AudioStreamPlayer2D = $grunt1
@onready var grunt_2: AudioStreamPlayer2D = $grunt2
@onready var voice_line_1: AudioStreamPlayer2D = $VoiceLine1
@onready var voice_line_2: AudioStreamPlayer2D = $VoiceLine2
@onready var voice_line_3: AudioStreamPlayer2D = $VoiceLine3
@onready var voice_line_heal: AudioStreamPlayer2D = $VoiceLineHeal
var last_voice_line: int = 0
var last_grunt: int = 0

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
	if Input.is_action_just_pressed("debug"):
		print(global_position.x,", ", global_position.y)

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

func death():
	health = 0
	print("game over")
	player_died.emit()
	health_changed.emit()

func shoot():
	energy -= shoot_cost
	var pos: Vector2 = shoot_src.global_position
	var projectile := projectile_scene.instantiate()
	projectile.position = pos
	shoot_sound.play()
	projectile.direction = pos.direction_to(get_global_mouse_position())
	var game = get_node("../GameCode")
	game.register_projectile(projectile)
	firerate.start(shoot_period)

func player_damage(damage: float):
	print("Took Damage: ", damage)
	if last_grunt >= 1:
		grunt_2.play()
		last_grunt = 0
	else:
		grunt_1.play()
		last_grunt += 1
	if last_voice_line == 0 and health <= 15:
		voice_line_1.play()
		last_voice_line += 1
	elif last_voice_line == 1 and health <= 10:
		voice_line_2.play()
		last_voice_line += 1
	elif last_voice_line == 2 and health <= 5:
		voice_line_3.play()
		last_voice_line += 1
	health -= damage
	if health <= 0:
		death()
		return
	health_changed.emit()

func heal_damage(heal_amount: float):
	health += heal_amount
	if health > max_health:
		health = max_health
	voice_line_heal.play()
	health_changed.emit()
