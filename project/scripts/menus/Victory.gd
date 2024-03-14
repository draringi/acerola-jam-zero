extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var time_taken_display: RichTextLabel = $CanvasLayer/Control/TimeTaken
	time_taken_display.text = "You completed the factory level in %.2f seconds" % GameStats.time_taken


func _button_hover():
	SoundSystem.button_sfx.button_hover()

func _restart_button_press():
	SoundSystem.button_sfx.button_push()
	get_tree().change_scene_to_file("res://scenes/levels/FactoryRuinsLevel.tscn")

func _menu_button_press():
	SoundSystem.button_sfx.button_push()
	get_tree().change_scene_to_file("res://scenes/menus/MainMenu.tscn")
