extends Node

var hud_ui = preload("res://scenes/HUD/hud.tscn")
var hud : HUD
var player :Player

# Called when the node enters the scene tree for the first time.
func _ready():
	hud = hud_ui.instantiate()
	hud.set_player(player)
	add_child(hud)

func set_player(new_player: Player):
	player = new_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func register_projectile(node):
	add_child(node)
