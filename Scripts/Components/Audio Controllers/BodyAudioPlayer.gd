extends AudioStreamPlayer
class_name BodyAudioPlayer

@export var player : Player
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
	if player.SFXtime.time_left <= 0 && player.velocity.length() > 0.01:
		player.SFXtime.start(0.45)
		self.stream = FootSFX
		self.pitch_scale = RNG.randf_range(0.9, 1.1)
		self.play()
