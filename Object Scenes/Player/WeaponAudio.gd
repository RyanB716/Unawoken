extends AudioStreamPlayer
class_name WeaponAudioPlayer

@export var AttackTrackArray = []

#SFX : AudioStream

var RNG = RandomNumberGenerator.new()

func PlaySFX():
	var index = RNG.randi_range(0, AttackTrackArray.size() - 1)
	self.stream = AttackTrackArray[index]
	self.play()
