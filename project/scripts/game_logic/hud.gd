extends Control

class_name HUD

@export var player: Player

var health_bar : ProgressBar
var energy_bar : ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar = $CanvasLayer/HealthBar
	energy_bar = $CanvasLayer/EnergyBar
	update_health()
	update_energy()

func set_player(new_player: Player):
	player = new_player
	new_player.health_changed.connect(update_health)

func update_health():
	health_bar.max_value = player.max_health
	health_bar.value = player.health

func update_energy():
	energy_bar.max_value = player.max_energy
	energy_bar.value = player.energy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_energy()
