extends AudioStreamPlayer
class_name BodyAudioPlayer

@export var VoiceTrackArray = []

@export var FootSFX : AudioStream

var RNG = RandomNumberGenerator.new()

func PlaySFX():
	var index = RNG.randi_range(0, VoiceTrackArray.size() - 1)
	self.stream = VoiceTrackArray[index]
	self.play()

func PlayStep():
	stream = FootSFX
	pitch_scale = RNG.randf_range(0.9, 1.1)
	play()
