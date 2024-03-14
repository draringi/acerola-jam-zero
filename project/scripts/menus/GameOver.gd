extends Control

func _on_ready():
	pass

func _button_hover():
	SoundSystem.button_sfx.button_hover()

func _restart_button_press():
	SoundSystem.button_sfx.button_push()
	get_tree().change_scene_to_file("res://scenes/levels/FactoryRuinsLevel.tscn")

func _menu_button_press():
	SoundSystem.button_sfx.button_push()
	get_tree().change_scene_to_file("res://scenes/menus/MainMenu.tscn")
