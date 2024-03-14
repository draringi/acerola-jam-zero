extends Node

class_name SFXManager

@onready var audio_button_hover: AudioStreamPlayer = $StreamButtonHover
@onready var audio_button_press: AudioStreamPlayer = $StreamButtonPush

func button_push():
	audio_button_press.play()

func button_hover():
	audio_button_hover.play()
