extends Control

var bgm : AudioStream = preload("res://assets/bgm/The Disturbance Within - loop.ogg")
@onready var settings = $Settings

# Called when the node enters the scene tree for the first time.
func _ready():
	settings.visible = false
	SoundSystem.FadeTo(bgm)

func _button_hover():
	SoundSystem.button_sfx.button_hover()

func _play_button_press():
	SoundSystem.button_sfx.button_push()
	get_tree().change_scene_to_file("res://scenes/levels/FactoryRuinsLevel.tscn")

func _quit_button_press():
	SoundSystem.button_sfx.button_push()
	get_tree().quit()

func _settings_button_press():
	SoundSystem.button_sfx.button_push()
	settings.visible = ! settings.visible
