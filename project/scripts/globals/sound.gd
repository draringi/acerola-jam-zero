extends Node

@onready var bgm_a: AudioStreamPlayer = $BGM_1
@onready var bgm_b: AudioStreamPlayer = $BGM_2
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var button_sfx: SFXManager = $SFX

func FadeTo(track: AudioStream, speed: float = 1):
	if bgm_a.playing and bgm_b.playing:
		return
	
	if bgm_b.playing:
		bgm_a.stream = track
		bgm_a.play()
		animator.play("fade_to_1", -1, speed)
	else:
		bgm_b.stream = track
		bgm_b.play()
		animator.play("fade_to_2", -1, speed)
