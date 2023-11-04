extends AudioStreamPlayer
class_name MenuAudio

@export var NewGameSFX : AudioStream
@export var Tick : AudioStream

func PlayNGSFX():
	stream = NewGameSFX
	play()

func PlayTick():
	stream = Tick
	play()
