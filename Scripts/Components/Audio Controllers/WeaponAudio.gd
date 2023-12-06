extends AudioStreamPlayer
class_name WeaponAudioPlayer

@export var AttackTrackArray = []

var RNG = RandomNumberGenerator.new()

#Play a random sfx when attacking
func PlaySFX():
	var index = RNG.randi_range(0, AttackTrackArray.size() - 1)
	self.stream = AttackTrackArray[index]
	self.play()
