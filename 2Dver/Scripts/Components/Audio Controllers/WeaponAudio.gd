extends AudioStreamPlayer
class_name WeaponAudioPlayer

@export_category("Track Arrays")
@export var SwingSFX : Array[AudioStream]

var RNG = RandomNumberGenerator.new()

#Play a random sfx when attacking
func PlaySwing():
	var index = RNG.randi_range(0, SwingSFX.size() - 1)
	stream = SwingSFX[index]
	play()
