extends Node2D

var game_logic = preload("res://scenes/HUD/game_code.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.set_camera_limits(-244, 2750, -240, 1357)
	var game = game_logic.instantiate()
	game.set_player($Player)
	add_child(game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

