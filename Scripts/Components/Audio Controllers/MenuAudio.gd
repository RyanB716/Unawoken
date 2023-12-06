extends AudioStreamPlayer
class_name MenuAudio

@export var NewGameSFX : AudioStream
@export var Tick : AudioStream

#Indicates a new game is being created
func PlayNGSFX():
	stream = NewGameSFX
	play()

#Indicates a button has been hovered
func PlayTick():
	stream = Tick
	play()
