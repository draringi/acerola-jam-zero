extends Control

@onready var MasterVolume: HSlider = $VBoxContainer/MasterVolumeSlider
@onready var MusicVolume: HSlider = $VBoxContainer/MusicVolumeSlider
@onready var SFXVolume: HSlider = $VBoxContainer/SFXVolumeSlider
@onready var VoicesVolume: HSlider = $VBoxContainer/VoicesVolumeSlider
@onready var OutputDevice: MenuButton = $VBoxContainer/OutputDeviceSelector
@onready var MasterIndex: int =  AudioServer.get_bus_index("Master")
@onready var MusicIndex: int =  AudioServer.get_bus_index("Music")
@onready var SFXIndex: int =  AudioServer.get_bus_index("SFX")
@onready var VoicesIndex: int =  AudioServer.get_bus_index("Voices")



# Called when the node enters the scene tree for the first time.
func _ready():
	MasterVolume.value = db_to_linear(AudioServer.get_bus_volume_db(MasterIndex))
	MusicVolume.value = db_to_linear(AudioServer.get_bus_volume_db(MusicIndex))
	SFXVolume.value = db_to_linear(AudioServer.get_bus_volume_db(SFXIndex))
	VoicesVolume.value = db_to_linear(AudioServer.get_bus_volume_db(VoicesIndex))
	var devices = AudioServer.get_output_device_list()
	var popup = OutputDevice.get_popup()
	for device in devices:
		popup.add_item(device)
	popup.index_pressed.connect(OutputSelected)


func setMasterVolume(value: float):
	AudioServer.set_bus_volume_db(MasterIndex, linear_to_db(value))

func setMusicVolume(value: float):
	AudioServer.set_bus_volume_db(MusicIndex, linear_to_db(value))

func setSFXVolume(value: float):
	AudioServer.set_bus_volume_db(SFXIndex, linear_to_db(value))

func setVoicesVolume(value: float):
	AudioServer.set_bus_volume_db(VoicesIndex, linear_to_db(value))

func OutputSelected(idx: int):
	var device = OutputDevice.get_popup().get_item_text(idx)
	AudioServer.output_device = device
