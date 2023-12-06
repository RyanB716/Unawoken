extends AudioStreamPlayer
class_name BodyAudioPlayer

@export var VoiceTrackArray = []

@export var FootSFX : AudioStream

var RNG = RandomNumberGenerator.new()

#Play a random voice sfx when attacking
func PlaySFX():
	var index = RNG.randi_range(0, VoiceTrackArray.size() - 1)
	self.stream = VoiceTrackArray[index]
	self.play()

#Play the sfx at a random pitch
func PlayStep():
	stream = FootSFX
	pitch_scale = RNG.randf_range(0.9, 1.1)
	play()
