extends Node2D

var game_logic = preload("res://scenes/HUD/game_code.tscn")
var intro_music = preload("res://assets/bgm/A Corrupted Factory - intro.ogg")
var main_music = preload("res://assets/bgm/A Corrupted Factory - main loop.ogg")
var victory_screen = preload("res://scenes/menus/Victory.tscn")
var time_elapsed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.set_camera_limits(-244, 5100, -240, 2650)
	var game = game_logic.instantiate()
	game.set_player($Player)
	add_child(game)
	SoundSystem.FadeTo(intro_music)
	Engine.time_scale = 1
	$FactoryBoss.boss_defeated.connect(complete_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta

func set_loop_music():
	SoundSystem.FadeTo(main_music, 0.5)

func complete_level():
	Engine.time_scale = 0
	GameStats.time_taken = time_elapsed
	var victory = victory_screen.instantiate()
	add_child(victory)
