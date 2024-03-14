extends Node

var hud_ui = preload("res://scenes/HUD/hud.tscn")
var gameover_menu = preload("res://scenes/menus/GameOver.tscn")
var hud : HUD
var gameover
var player :Player

# Called when the node enters the scene tree for the first time.
func _ready():
	hud = hud_ui.instantiate()
	hud.set_player(player)
	add_child(hud)
	player.player_died.connect(_game_over)

func set_player(new_player: Player):
	player = new_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func register_projectile(node):
	add_child(node)

func _game_over():
	Engine.time_scale = 0
	gameover = gameover_menu.instantiate()
	add_child(gameover)
