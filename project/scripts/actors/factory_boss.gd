extends BaseEnemy

signal boss_defeated

@onready var sprite: Sprite2D = $FactoryBoss
@onready var ability_duration: Timer = $AbilityDuration
@onready var ability_cooldown: Timer = $AbilityCooldown
@onready var flee_timer: Timer = $FleeTimer
@onready var ability_sound: AudioStreamPlayer2D = $AbilitySound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
var flee: bool
var melee_damage: float = 3
var last_seen: Vector2 = Vector2.INF


func _ready():
	target = get_node("../Player")
	eyes = $Eyes
	max_health = 20
	health = 20
	speed = 450
	set_sight(1000)
	chase = false
	flee = false

func vector_string(v :Vector2) -> String:
	return "%f, %f" % [v.x, v.y]

func _process(_delta):
	if can_see_player:
		chase = true
		if ability_duration.is_stopped() and ability_cooldown.is_stopped():
			use_ability()
		last_seen = target.global_position
	if Input.is_action_just_pressed("debug"):
		print(name)
		print("current: ", vector_string(global_position))
		print("next: ", vector_string(navigation_agent.get_next_path_position()))
		print("last seen: ", vector_string(last_seen))
		print("target?: ", vector_string(navigation_agent.target_position))
		
func end_flee():
	flee = false

func death():
	print("boss killed")
	death_sound.play()
	boss_defeated.emit()
	

func use_ability():
	if not (ability_cooldown.is_stopped() and ability_duration.is_stopped()):
		return
	gravity *= -1
	up_direction = -up_direction
	sprite.flip_v = true
	ability_sound.play()
	ability_duration.start(2)

func end_ability():
	gravity *= -1
	up_direction = -up_direction
	sprite.flip_v = false
	ability_cooldown.start(8)


func get_desired_direction():
	if flee:
		var dir = global_position.direction_to(target.global_position)
		if dir.x < 0:
			return MoveDirection.RIGHT
		return MoveDirection.LEFT
	elif chase:
		var dir = global_position.direction_to(target.global_position)
		if dir.x > 0:
			return MoveDirection.RIGHT
		if dir.x < 0:
			return MoveDirection.LEFT
	return MoveDirection.STOP

func _handle_collide(object):
	if flee_timer.is_stopped() and "player_damage" in object:
		object.player_damage(melee_damage)
		if object.global_position.y - 30 > global_position.y:
			print("Jump Attack")
			object.player_damage(melee_damage) # Double Damage on fall
		flee = true
		flee_timer.start(2)
